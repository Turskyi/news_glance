import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/domain_services/search_persistence.dart';
import 'package:news_glance/domain_services/use_cases/compute_search_briefing_checksum.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
    this._newsRepository,
    this._searchPersistence,
    this._briefingPersistence,
    this._computeChecksum,
    this._settingsService,
  ) : super(const SearchInitialState()) {
    on<LoadSearchHistoryEvent>(_loadHistory);
    on<PerformSearchEvent>(_performSearch, transformer: restartable());
    on<ClearSearchHistoryEvent>(_clearHistory);
  }

  final NewsRepository _newsRepository;
  final SearchPersistence _searchPersistence;
  final BriefingPersistence _briefingPersistence;
  final ComputeSearchBriefingChecksum _computeChecksum;
  final SettingsService _settingsService;

  FutureOr<void> _loadHistory(
    LoadSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final List<String> history = await _searchPersistence.getRecentSearches();
    emit(SearchInitialState(recentSearches: history));
  }

  FutureOr<void> _performSearch(
    PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      return;
    } else {
      emit(const SearchLoadingState());

      try {
        await _searchPersistence.saveRecentSearch(query);
        final List<NewsArticle> articles = await _newsRepository.searchNews(
          query,
        );

        if (articles.isEmpty) {
          emit(
            SearchResultsLoadedState(
              query: query,
              articles: const <NewsArticle>[],
            ),
          );
        } else {
          emit(SearchResultsLoadedState(query: query, articles: articles));

          // Now generate/load briefing
          try {
            final AppLocale locale = await _settingsService.getLocale();
            final ConclusionUiStyle style = await _settingsService
                .getConclusionUiStyle();

            final int checksum = _computeChecksum(
              query: query,
              briefingType: style.name,
              articles: articles,
            );

            ActionableInsight? briefing;

            // Try cache first
            if (style.isConclusion) {
              final String? cached = await _briefingPersistence.getConclusion(
                checksum,
              );
              if (cached != null) {
                briefing = ActionableInsight(
                  conclusion: cached,
                  level: ActionableInsightLevel.neutral,
                  probability: 0.0,
                  category: InsightCategory.general,
                );
              } else {
                // Not in cache
              }
            } else if (style.isSummary) {
              final String? cached = await _briefingPersistence.getSummary(
                checksum,
              );
              if (cached != null) {
                briefing = ActionableInsight(
                  conclusion: cached,
                  level: ActionableInsightLevel.neutral,
                  probability: 0.0,
                  category: InsightCategory.general,
                );
              } else {
                // Not in cache
              }
            } else {
              briefing = await _briefingPersistence.getInsight(checksum);
            }

            if (briefing != null) {
              emit(
                SearchResultsLoadedState(
                  query: query,
                  articles: articles,
                  insight: briefing,
                ),
              );
            } else {
              // Not in cache, request from AI
              if (style.isConclusion) {
                final String text = await _newsRepository.getNewsConclusion(
                  articles,
                  lang: locale.languageCode,
                );
                await _briefingPersistence.saveConclusion(
                  checksum: checksum,
                  text: text,
                );
                briefing = ActionableInsight(
                  conclusion: text,
                  level: ActionableInsightLevel.neutral,
                  probability: 0.0,
                  category: InsightCategory.general,
                );
              } else if (style.isSummary) {
                final String text = await _newsRepository.getNewsSummary(
                  articles,
                  lang: locale.languageCode,
                );
                await _briefingPersistence.saveSummary(
                  checksum: checksum,
                  text: text,
                );
                briefing = ActionableInsight(
                  conclusion: text,
                  level: ActionableInsightLevel.neutral,
                  probability: 0.0,
                  category: InsightCategory.general,
                );
              } else {
                briefing = await _newsRepository.getActionableInsight(
                  articles,
                  lang: locale.languageCode,
                );
                await _briefingPersistence.saveInsight(
                  checksum: checksum,
                  insight: briefing,
                );
              }

              emit(
                SearchResultsLoadedState(
                  query: query,
                  articles: articles,
                  insight: briefing,
                ),
              );
            }
          } on BadRequestException catch (e) {
            emit(
              SearchResultsLoadedState(
                query: query,
                articles: articles,
                errorMessage: e.message,
              ),
            );
          } catch (e) {
            emit(
              SearchResultsLoadedState(
                query: query,
                articles: articles,
                errorMessage: _mapErrorToMessage(e),
              ),
            );
          }
        }
      } on SocketException {
        emit(
          const SearchErrorState(
            errorMessage:
                'No internet connection. Please check your network settings.',
          ),
        );
      } catch (e) {
        emit(SearchErrorState(errorMessage: _mapErrorToMessage(e)));
      }
    }
  }

  FutureOr<void> _clearHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    await _searchPersistence.clearRecentSearches();
    emit(const SearchInitialState());
  }

  String _mapErrorToMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timed out. Please try again later.';
      } else {
        return 'Network error: ${error.message}';
      }
    } else {
      return 'An unexpected error occurred.';
    }
  }
}
