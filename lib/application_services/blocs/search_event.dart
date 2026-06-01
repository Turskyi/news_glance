part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class LoadSearchHistoryEvent extends SearchEvent {
  const LoadSearchHistoryEvent();
}

class PerformSearchEvent extends SearchEvent {
  const PerformSearchEvent(this.query);

  final String query;
}

class ClearSearchHistoryEvent extends SearchEvent {
  const ClearSearchHistoryEvent();
}
