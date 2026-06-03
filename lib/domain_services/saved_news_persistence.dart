import 'package:news_glance/domain_models/news_article.dart';

abstract interface class SavedNewsPersistence {
  const SavedNewsPersistence();

  Future<void> saveArticle(NewsArticle article);

  Future<List<NewsArticle>> getSavedArticles();

  Future<void> deleteArticle(String urlSource);

  Future<bool> isSaved(String urlSource);

  Future<void> clearAll();
}
