part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  const NewsState();

  bool get canUpdateHomeWidget {
    if (kIsWeb) {
      return false;
    }
    final NewsState state = this;
    return state is LoadedConclusionState &&
        state.insight.conclusion.isNotEmpty;
  }
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
  const LoadedConclusionState({required super.news, required this.insight});

  final ActionableInsight insight;
}

final class BriefingSharingSuccess extends LoadedConclusionState {
  const BriefingSharingSuccess({
    required super.news,
    required super.insight,
    required this.result,
  });

  final SharingResult result;
}

final class ErrorState extends NewsState {
  const ErrorState({this.errorMessage = 'Something went wrong'});

  final String errorMessage;
}
