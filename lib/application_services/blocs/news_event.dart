part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {
  const NewsEvent();
}

class LoadNewsEvent extends NewsEvent {
  const LoadNewsEvent();
}
