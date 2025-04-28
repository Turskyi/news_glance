part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  const NewsState();

  bool get canUpdateHomeWidget =>
      !kIsWeb &&
      !Platform.isMacOS &&
      this is LoadedConclusionState &&
      (this as LoadedConclusionState).conclusion.isNotEmpty;
}

class LoadingNewsState extends NewsState {
  const LoadingNewsState();
}

class LoadedNewsState extends NewsState {
  const LoadedNewsState({required this.news});

  final List<NewsArticle> news;
}

final class NewsConclusionError extends LoadedNewsState {
  const NewsConclusionError({
    required super.news,
    this.errorMessage = 'Something went wrong',
  });

  final String errorMessage;
}

class LoadedConclusionState extends LoadedNewsState {
  const LoadedConclusionState({
    required super.news,
    required this.conclusion,
  });

  final String conclusion;
}

final class ErrorState extends NewsState {
  const ErrorState({
    this.errorMessage = 'Something went wrong',
  });

  final String errorMessage;
}
