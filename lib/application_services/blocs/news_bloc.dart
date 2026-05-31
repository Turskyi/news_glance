import 'dart:async';
import 'dart:io' show SocketException;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/domain_services/sharing_service.dart';
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
  NewsBloc(this._newsRepository, this._sharingService)
    : super(const LoadingNewsState()) {
    debugPrint('NewsBloc: initialized');
    on<LoadNewsEvent>((LoadNewsEvent event, Emitter<NewsState> emit) {
      debugPrint('NewsBloc: [LoadNewsEvent] received');
      return _loadNews(event, emit);
    }, transformer: sequential());
    on<RegenerateInsightEvent>(_regenerateInsight, transformer: restartable());
    on<ShareBriefingEvent>(_shareBriefing);
  }

  final NewsRepository _newsRepository;
  final SharingService _sharingService;

  // Caches keyed by the last news checksum — avoid regenerating if same news
  int? _lastNewsHash;
  ActionableInsight? _cachedActionableInsight;
  String? _cachedConclusionText;
  String? _cachedSummaryText;

  FutureOr<void> _loadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    debugPrint('NewsBloc: [_loadNews] triggered');
    try {
      final SettingsService settingsService = SettingsService();
      final Locale locale = await settingsService.getLocale();
      final String countryCode = locale.languageCode == 'uk'
          ? 'ua'
          : constants.internationalCode;

      debugPrint(
        'NewsBloc: [_loadNews] fetching for countryCode: $countryCode',
      );
      final List<NewsArticle> news = await _newsRepository.getNews(
        countryCode: countryCode,
      );
      debugPrint(
        'NewsBloc: [_loadNews] repository returned ${news.length} articles',
      );

      if (news.isEmpty) {
        debugPrint(
          'NewsBloc: [_loadNews] news is empty, emitting LoadedNewsState([])',
        );
        emit(const LoadedNewsState(news: <NewsArticle>[]));
        return;
      }

      emit(LoadedNewsState(news: news));

      try {
        final ConclusionUiStyle style = await settingsService
            .getConclusionUiStyle();
        debugPrint('NewsBloc: [_loadNews] using style: $style for AI');

        ActionableInsight insight;

        if (style.isConclusion) {
          debugPrint('NewsBloc: [_loadNews] calling getNewsConclusion');
          final String conclusionText = await _newsRepository.getNewsConclusion(
            news,
            lang: locale.languageCode,
          );
          _cachedConclusionText = conclusionText;
          _cachedActionableInsight = null;
          _cachedSummaryText = null;

          insight = ActionableInsight(
            conclusion: conclusionText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );
        } else if (style.isSummary) {
          debugPrint('NewsBloc: [_loadNews] calling getNewsSummary');
          final String summaryText = await _newsRepository.getNewsSummary(
            news,
            lang: locale.languageCode,
          );
          _cachedSummaryText = summaryText;
          _cachedConclusionText = null;
          _cachedActionableInsight = null;

          insight = ActionableInsight(
            conclusion: summaryText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );
        } else {
          debugPrint('NewsBloc: [_loadNews] calling getActionableInsight');
          insight = await _newsRepository.getActionableInsight(
            news,
            lang: locale.languageCode,
          );
          _cachedActionableInsight = insight;
          _cachedConclusionText = null;
          _cachedSummaryText = null;
        }

        final int checksum = computeNewsHash(news);
        _lastNewsHash = checksum;

        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? ct = _cachedConclusionText;
          if (ct != null) {
            await prefs.setString(storage_keys.aiCacheConclusion(checksum), ct);
          }
          final String? st = _cachedSummaryText;
          if (st != null) {
            await prefs.setString(storage_keys.aiCacheSummary(checksum), st);
          }
          final ActionableInsight? ci = _cachedActionableInsight;
          if (ci != null) {
            await prefs.setString(
              storage_keys.aiCacheInsightConclusion(checksum),
              ci.conclusion,
            );
            await prefs.setString(
              storage_keys.aiCacheInsightLevel(checksum),
              ci.level.value,
            );
            await prefs.setDouble(
              storage_keys.aiCacheInsightProbability(checksum),
              ci.probability,
            );
            await prefs.setString(
              storage_keys.aiCacheInsightCategory(checksum),
              ci.category.value,
            );
          }
          await prefs.setInt(
            storage_keys.newsLastFetchAt,
            DateTime.now().millisecondsSinceEpoch,
          );
        } catch (_) {}

        emit(LoadedConclusionState(news: news, insight: insight));
      } on BadRequestException catch (e) {
        debugPrint('NewsBloc: [_loadNews] BadRequestException: ${e.message}');
        emit(NewsConclusionError(news: news, errorMessage: e.message));
      } catch (e) {
        debugPrint('NewsBloc: [_loadNews] AI error: $e');
        emit(
          NewsConclusionError(news: news, errorMessage: 'Unexpected error: $e'),
        );
      }
    } on SocketException catch (e) {
      debugPrint('NewsBloc: [_loadNews] SocketException: $e');
      emit(
        const ErrorState(
          errorMessage:
              'No internet connection. Please check your network settings.',
        ),
      );
    } catch (e) {
      debugPrint('NewsBloc: [_loadNews] General error: $e');
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
      if (_lastNewsHash == checksum) {
        final String? conclusionText = _cachedConclusionText;
        if (event.style == ConclusionUiStyle.conclusion &&
            conclusionText != null) {
          final ActionableInsight cached = ActionableInsight(
            conclusion: conclusionText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );
          emit(LoadedConclusionState(news: current.news, insight: cached));
          return;
        }

        final String? summaryText = _cachedSummaryText;
        if (event.style == ConclusionUiStyle.summary && summaryText != null) {
          final ActionableInsight cached = ActionableInsight(
            conclusion: summaryText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );
          emit(LoadedConclusionState(news: current.news, insight: cached));
          return;
        }

        final ActionableInsight? cachedInsight = _cachedActionableInsight;
        if (event.style == ConclusionUiStyle.insight && cachedInsight != null) {
          emit(
            LoadedConclusionState(news: current.news, insight: cachedInsight),
          );
          return;
        }
      }

      // If not cached in memory, try SharedPreferences
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (event.style.isConclusion) {
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
        } else if (event.style.isSummary) {
          final String? stored = prefs.getString(
            storage_keys.aiCacheSummary(checksum),
          );
          if (stored != null && stored.isNotEmpty) {
            _cachedSummaryText = stored;
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
        final SettingsService settingsService = SettingsService();
        final Locale locale = await settingsService.getLocale();
        final String lang = locale.languageCode;

        if (event.style.isConclusion) {
          final String conclusionText = await _newsRepository.getNewsConclusion(
            articles,
            lang: lang,
          );
          _cachedConclusionText = conclusionText;
          _cachedActionableInsight = null;
          _cachedSummaryText = null;
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
        } else if (event.style.isSummary) {
          final String summaryText = await _newsRepository.getNewsSummary(
            articles,
            lang: lang,
          );
          _cachedSummaryText = summaryText;
          _cachedConclusionText = null;
          _cachedActionableInsight = null;
          _lastNewsHash = checksum;

          // persist
          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
              storage_keys.aiCacheSummary(checksum),
              summaryText,
            );
          } catch (_) {}

          final ActionableInsight insight = ActionableInsight(
            conclusion: summaryText,
            level: ActionableInsightLevel.neutral,
            probability: 0.0,
            category: InsightCategory.general,
          );

          emit(LoadedConclusionState(news: current.news, insight: insight));
        } else {
          final ActionableInsight insight = await _newsRepository
              .getActionableInsight(articles, lang: lang);
          _cachedActionableInsight = insight;
          _cachedConclusionText = null;
          _cachedSummaryText = null;
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

  FutureOr<void> _shareBriefing(
    ShareBriefingEvent event,
    Emitter<NewsState> emit,
  ) async {
    final NewsState current = state;
    if (current is LoadedConclusionState) {
      final SharingResult result = await _sharingService.shareBriefing(
        event.text,
      );

      switch (result) {
        case SharingResult.shared:
        case SharingResult.copiedToClipboard:
          emit(
            BriefingSharingSuccess(
              news: current.news,
              insight: current.insight,
              result: result,
            ),
          );
        case SharingResult.failed:
          break;
      }

      // Re-emit the original state to clear the feedback state.
      // Usually, side effects like SnackBars are better handled with a Stream
      // or a specific action. But if we use state, we might want to revert it
      // so the listener doesn't trigger again on rebuild.
      emit(LoadedConclusionState(news: current.news, insight: current.insight));
    }
  }
}
