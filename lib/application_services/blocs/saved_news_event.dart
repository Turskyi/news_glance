import 'package:news_glance/domain_models/news_article.dart';

abstract interface class SavedNewsEvent {
  const SavedNewsEvent();
}

class LoadSavedNews extends SavedNewsEvent {
  const LoadSavedNews();
}

class RemoveSavedArticle extends SavedNewsEvent {
  const RemoveSavedArticle({required this.urlSource});

  final String urlSource;
}

class ToggleSaveArticle extends SavedNewsEvent {
  const ToggleSaveArticle({required this.article});

  final NewsArticle article;
}
