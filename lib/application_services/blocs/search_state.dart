part of 'search_bloc.dart';

sealed class SearchState {
  const SearchState();
}

class SearchInitialState extends SearchState {
  const SearchInitialState({this.recentSearches = const <String>[]});

  final List<String> recentSearches;
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchResultsLoadedState extends SearchState {
  const SearchResultsLoadedState({
    required this.query,
    required this.articles,
    this.insight,
    this.errorMessage,
  });

  final String query;
  final List<NewsArticle> articles;
  final ActionableInsight? insight;
  final String? errorMessage;
}

class SearchErrorState extends SearchState {
  const SearchErrorState({required this.errorMessage});

  final String errorMessage;
}
