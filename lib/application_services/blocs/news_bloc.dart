import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/res/constants.dart' as country;

part 'news_event.dart';
part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._newsRepository) : super(const LoadingNewsState()) {
    on<LoadNewsEvent>((LoadNewsEvent event, Emitter<NewsState> emit) async {
      String? code =
          WidgetsBinding.instance.platformDispatcher.locale.countryCode;
      final List<NewsArticle> news = await _newsRepository.getNews(
        countryCode: code ?? country.canadaCode,
      );
      emit(LoadedNewsState(news: news));
      final String prompt =
          news.take(3).map((NewsArticle article) => article.title).join('; ');
      final String conclusion = await _newsRepository.getNewsConclusion(prompt);
      emit(LoadedConclusionState(news: news, conclusion: conclusion));
    });
  }

  final NewsRepository _newsRepository;
}
