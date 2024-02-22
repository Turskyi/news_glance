import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._newsRepository) : super(const LoadingNewsState()) {
    on<LoadNewsEvent>((LoadNewsEvent event, Emitter<NewsState> emit) async {
      List<NewsArticle> news = await _newsRepository.getNews();
      emit(LoadedNewsState(news: news));
    });
  }

  final NewsRepository _newsRepository;
}
