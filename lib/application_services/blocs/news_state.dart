part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  const NewsState();
}

class LoadingNewsState extends NewsState {
  const LoadingNewsState();
}

class LoadedNewsState extends NewsState {
  const LoadedNewsState({required this.news});

  final List<NewsArticle> news;
}

class LoadedConclusionState extends LoadedNewsState {
  const LoadedConclusionState({
    required super.news,
    required this.conclusion,
  });

  final String conclusion;
}
