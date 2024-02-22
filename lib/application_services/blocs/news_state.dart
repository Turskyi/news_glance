part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  const NewsState();
}

class LoadingNewsState extends NewsState {
  const LoadingNewsState();
}

class LoadedNewsState extends NewsState {
  const LoadedNewsState({required List<NewsArticle> news});
}
