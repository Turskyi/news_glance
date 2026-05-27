import 'dart:async';
import 'dart:io' show SocketException;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

import 'news_helpers.dart';

part 'news_event.dart';
part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._newsRepository) : super(const LoadingNewsState()) {
    on<LoadNewsEvent>(_loadNews);
    on<RegenerateInsightEvent>(_regenerateInsight);
  }

  final NewsRepository _newsRepository;

  // Caches keyed by the last news checksum — avoid regenerating if same news
  int? _lastNewsHash;
  ActionableInsight? _cachedActionableInsight;
  String? _cachedConclusionText;

  FutureOr<void> _loadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    try {
      final List<NewsArticle> news = await _newsRepository.getNews(
        countryCode: constants.internationalCode,
      );
      emit(LoadedNewsState(news: news));
      if (news.isNotEmpty) {
        final List<NewsArticle> articles = news
            .take(constants.newsMax)
            .toList();

        try {
          // Check user-selected UI style: insight (new) or conclusion (legacy)
          final SettingsService settingsService = SettingsService();
          final ConclusionUiStyle style = await settingsService
              .getConclusionUiStyle();

          ActionableInsight insight;

          if (style == ConclusionUiStyle.conclusion) {
            // Call the conclusion endpoint and wrap into an actionable insight.
            final String conclusionText = await _newsRepository
                .getNewsConclusion(articles);
            // cache
            _cachedConclusionText = conclusionText;
            _cachedActionableInsight = null;

            insight = ActionableInsight(
              conclusion: conclusionText,
              level: ActionableInsightLevel.neutral,
              probability: 0.0,
              category: InsightCategory.general,
            );
          } else {
            // New behavior
            insight = await _newsRepository.getActionableInsight(articles);
            // cache
            _cachedActionableInsight = insight;
            _cachedConclusionText = null;
          }

          // compute news checksum and store
          _lastNewsHash = computeNewsHash(articles);

          // persist caches for this checksum
          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final int checksum = _lastNewsHash!;
            if (_cachedConclusionText != null) {
              await prefs.setString(
                storage_keys.aiCacheConclusion(checksum),
                _cachedConclusionText!,
              );
            }
            if (_cachedActionableInsight != null) {
              final ActionableInsight cached = _cachedActionableInsight!;
              await prefs.setString(
                storage_keys.aiCacheInsightConclusion(checksum),
                cached.conclusion,
              );
              await prefs.setString(
                storage_keys.aiCacheInsightLevel(checksum),
                cached.level.value,
              );
              await prefs.setDouble(
                storage_keys.aiCacheInsightProbability(checksum),
                cached.probability,
              );
              await prefs.setString(
                storage_keys.aiCacheInsightCategory(checksum),
                cached.category.value,
              );
            }

            // store last fetch timestamp so UI can conditionally show manual
            // refresh
            await prefs.setInt(
              storage_keys.newsLastFetchAt,
              DateTime.now().millisecondsSinceEpoch,
            );
          } catch (_) {}

          emit(LoadedConclusionState(news: news, insight: insight));
        } on BadRequestException catch (e) {
          emit(NewsConclusionError(news: news, errorMessage: e.message));
        } catch (e) {
          emit(
            NewsConclusionError(
              news: news,
              errorMessage: 'Unexpected error: $e',
            ),
          );
        }
      }
    } on SocketException catch (_) {
      // Handle network errors.
      emit(
        const ErrorState(
          errorMessage:
              'No internet connection. '
              'Please check your network settings.',
        ),
      );
    } on DioException catch (e) {
      //DioException includes network error, and other.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        emit(
          const ErrorState(
            errorMessage:
                'Failed to connect to the server. '
                'Please check your internet connection.',
          ),
        );
      } else if (e.response != null) {
        // Server returned an error response.
        final int? statusCode = e.response?.statusCode;
        String errorMessage = 'An unexpected server error occurred.';

        if (statusCode != null) {
          errorMessage = 'Server error: $statusCode.';
        }

        if (statusCode == 404) {
          errorMessage = 'The requested resource was not found.';
        } else if (statusCode != null && statusCode >= 500) {
          errorMessage = 'A server error occurred. Please try again later.';
        }

        emit(ErrorState(errorMessage: errorMessage));
      } else {
        // Other errors.
        emit(
          const ErrorState(
            errorMessage: 'An unexpected error occurred while fetching data.',
          ),
        );
      }
    } catch (e) {
      // Handle other errors.
      emit(const ErrorState(errorMessage: 'An unexpected error occurred.'));
    }
  }

  FutureOr<void> _regenerateInsight(
    RegenerateInsightEvent event,
    Emitter<NewsState> emit,
  ) async {
    final NewsState current = state;
    if (current is LoadedNewsState) {
      final List<NewsArticle> articles = current.news
          .take(constants.newsMax)
          .toList();
      final int checksum = computeNewsHash(articles);

      // If checksum matches and cached value exists in memory, reuse it
      if (_lastNewsHash != null && _lastNewsHash == checksum) {
        if (event.style == ConclusionUiStyle.conclusion &&
            _cachedConclusionText != null) {
          final ActionableInsight cached = ActionableInsight(
            conclusion: _cachedConclusionText!,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );
          emit(LoadedConclusionState(news: current.news, insight: cached));
          return;
        }

        if (event.style == ConclusionUiStyle.insight &&
            _cachedActionableInsight != null) {
          emit(
            LoadedConclusionState(
              news: current.news,
              insight: _cachedActionableInsight!,
            ),
          );
          return;
        }
      }

      // If not cached in memory, try SharedPreferences
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (event.style == ConclusionUiStyle.conclusion) {
          final String? stored = prefs.getString(
            storage_keys.aiCacheConclusion(checksum),
          );
          if (stored != null && stored.isNotEmpty) {
            _cachedConclusionText = stored;
            _lastNewsHash = checksum;
            final ActionableInsight cached = ActionableInsight(
              conclusion: stored,
              level: ActionableInsightLevel.neutral,
              probability: 0.0,
              category: InsightCategory.general,
            );
            emit(LoadedConclusionState(news: current.news, insight: cached));
            return;
          }
        } else {
          final String? conclusion = prefs.getString(
            storage_keys.aiCacheInsightConclusion(checksum),
          );
          final String? levelStr = prefs.getString(
            storage_keys.aiCacheInsightLevel(checksum),
          );
          final double? prob = prefs.getDouble(
            storage_keys.aiCacheInsightProbability(checksum),
          );
          final String? categoryStr = prefs.getString(
            storage_keys.aiCacheInsightCategory(checksum),
          );

          if (conclusion != null && conclusion.isNotEmpty) {
            final ActionableInsight cached = ActionableInsight(
              conclusion: conclusion,
              level: ActionableInsightLevel.fromString(levelStr ?? 'NEUTRAL'),
              probability: prob ?? 0.0,
              category: InsightCategory.fromString(categoryStr ?? 'GENERAL'),
            );
            _cachedActionableInsight = cached;
            _lastNewsHash = checksum;
            emit(LoadedConclusionState(news: current.news, insight: cached));
            return;
          }
        }
      } catch (_) {
        // ignore prefs errors and fall through to live regeneration
      }

      try {
        if (event.style == ConclusionUiStyle.conclusion) {
          final String conclusionText = await _newsRepository.getNewsConclusion(
            articles,
          );
          _cachedConclusionText = conclusionText;
          _cachedActionableInsight = null;
          _lastNewsHash = checksum;

          // persist
          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
              storage_keys.aiCacheConclusion(checksum),
              conclusionText,
            );
          } catch (_) {}

          final ActionableInsight insight = ActionableInsight(
            conclusion: conclusionText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );

          emit(LoadedConclusionState(news: current.news, insight: insight));
        } else {
          final ActionableInsight insight = await _newsRepository
              .getActionableInsight(articles);
          _cachedActionableInsight = insight;
          _cachedConclusionText = null;
          _lastNewsHash = checksum;

          // persist
          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
              storage_keys.aiCacheInsightConclusion(checksum),
              insight.conclusion,
            );
            await prefs.setString(
              storage_keys.aiCacheInsightLevel(checksum),
              insight.level.value,
            );
            await prefs.setDouble(
              storage_keys.aiCacheInsightProbability(checksum),
              insight.probability,
            );
            await prefs.setString(
              storage_keys.aiCacheInsightCategory(checksum),
              insight.category.value,
            );
          } catch (_) {}

          emit(LoadedConclusionState(news: current.news, insight: insight));
        }
      } on BadRequestException catch (e) {
        emit(NewsConclusionError(news: current.news, errorMessage: e.message));
      } catch (e) {
        emit(
          NewsConclusionError(
            news: current.news,
            errorMessage: 'Unexpected error: $e',
          ),
        );
      }
      return;
    }

    // If news not loaded, trigger a full load
    add(const LoadNewsEvent());
  }
}
