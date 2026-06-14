import 'package:news_glance/domain_models/news_article.dart';

abstract interface class SavedNewsState {
  const SavedNewsState();
}

class SavedNewsError extends SavedNewsState {
  const SavedNewsError({required this.message});

  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! SavedNewsError) {
      return false;
    }
    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class SavedNewsLoaded extends SavedNewsState {
  const SavedNewsLoaded({required this.articles});

  final List<NewsArticle> articles;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! SavedNewsLoaded) {
      return false;
    }
    return other.articles == articles;
  }

  @override
  int get hashCode => articles.hashCode;
}

class SavedNewsInitial extends SavedNewsState {
  const SavedNewsInitial();
}

class SavedNewsLoading extends SavedNewsState {
  const SavedNewsLoading();
}
