import 'dart:async';
import 'dart:io' show Platform, SocketException;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/res/constants.dart' as constants;

part 'news_event.dart';
part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._newsRepository) : super(const LoadingNewsState()) {
    on<LoadNewsEvent>(_loadNews);
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _loadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    try {
      final List<NewsArticle> news = await _newsRepository.getNews(
        countryCode: constants.usaCode,
      );
      emit(LoadedNewsState(news: news));
      if (news.isNotEmpty) {
        final List<NewsArticle> articles = news
            .take(
              constants.newsMax,
            )
            .toList();

        try {
          final String conclusion = await _newsRepository.getNewsConclusion(
            articles,
          );
          emit(LoadedConclusionState(news: news, conclusion: conclusion));
        } on BadRequestException catch (e) {
          emit(
            NewsConclusionError(
              news: news,
              errorMessage: e.message,
            ),
          );
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
          errorMessage: 'No internet connection. '
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
            errorMessage: 'Failed to connect to the server. '
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
}
