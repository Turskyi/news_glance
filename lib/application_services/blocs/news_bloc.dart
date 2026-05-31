import 'dart:async';
import 'dart:io' show SocketException;

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/domain_services/sharing_service.dart';
import 'package:news_glance/domain_services/use_cases/compute_news_checksum.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';
import 'package:news_glance/res/constants.dart' as constants;

part 'news_event.dart';
part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(
    this._newsRepository,
    this._sharingService,
    this._computeNewsChecksum,
    this._briefingPersistence,
    this._settingsService,
  ) : super(const LoadingNewsState()) {
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
  final ComputeNewsChecksum _computeNewsChecksum;
  final BriefingPersistence _briefingPersistence;
  final SettingsService _settingsService;

  // Caches keyed by the last news checksum — avoid regenerating if same news
  int? _lastNewsHash;
  ActionableInsight? _cachedActionableInsight;
  String? _cachedConclusionText;
  String? _cachedSummaryText;

  FutureOr<void> _loadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    debugPrint('NewsBloc: [_loadNews] triggered');
    try {
      final AppLocale locale = await _settingsService.getLocale();
      final String countryCode = locale.isUkrainian
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
        final ConclusionUiStyle style = await _settingsService
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

        final int checksum = _computeNewsChecksum(news);
        _lastNewsHash = checksum;

        try {
          final String? ct = _cachedConclusionText;
          if (ct != null) {
            await _briefingPersistence.saveConclusion(
              checksum: checksum,
              text: ct,
            );
          }
          final String? st = _cachedSummaryText;
          if (st != null) {
            await _briefingPersistence.saveSummary(
              checksum: checksum,
              text: st,
            );
          }
          final ActionableInsight? ci = _cachedActionableInsight;
          if (ci != null) {
            await _briefingPersistence.saveInsight(
              checksum: checksum,
              insight: ci,
            );
          }
          await _briefingPersistence.saveLastFetchTime(DateTime.now());
        } catch (_) {}

        emit(LoadedConclusionState(news: news, insight: insight));
      } on BadRequestException catch (e) {
        debugPrint('NewsBloc: [_loadNews] BadRequestException: ${e.message}');
        emit(NewsConclusionError(news: news, errorMessage: e.message));
      } catch (e) {
        debugPrint('NewsBloc: [_loadNews] AI error: $e');
        final String errorMessage = _mapErrorToMessage(e);
        emit(NewsConclusionError(news: news, errorMessage: errorMessage));
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
      final String errorMessage = _mapErrorToMessage(e);
      emit(ErrorState(errorMessage: errorMessage));
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is DioException) {
      if (kIsWeb && error.message?.contains('XMLHttpRequest onError') == true) {
        return 'Network error: This might be a CORS issue (a security '
            'restriction that prevents the browser from accessing the server) '
            'or the server is unreachable.';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timed out. Please try again later.';
      }
      return 'Network error: ${error.message}';
    }
    return 'An unexpected error occurred.';
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
      final int checksum = _computeNewsChecksum(articles);

      final AppLocale locale = await _settingsService.getLocale();
      final String lang = locale.languageCode;

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

      // If not cached in memory, try persistence
      try {
        if (event.style.isConclusion) {
          final String? stored = await _briefingPersistence.getConclusion(
            checksum,
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
          final String? stored = await _briefingPersistence.getSummary(
            checksum,
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
          final ActionableInsight? cached = await _briefingPersistence
              .getInsight(checksum);

          if (cached != null) {
            _cachedActionableInsight = cached;
            _lastNewsHash = checksum;
            emit(LoadedConclusionState(news: current.news, insight: cached));
            return;
          }
        }
      } catch (_) {
        // ignore persistence errors and fall through to live regeneration
      }

      try {
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
            await _briefingPersistence.saveConclusion(
              checksum: checksum,
              text: conclusionText,
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
            await _briefingPersistence.saveSummary(
              checksum: checksum,
              text: summaryText,
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
            await _briefingPersistence.saveInsight(
              checksum: checksum,
              insight: insight,
            );
          } catch (_) {}

          emit(LoadedConclusionState(news: current.news, insight: insight));
        }
      } on BadRequestException catch (e) {
        emit(NewsConclusionError(news: current.news, errorMessage: e.message));
      } catch (e) {
        final String errorMessage = _mapErrorToMessage(e);
        emit(
          NewsConclusionError(news: current.news, errorMessage: errorMessage),
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
