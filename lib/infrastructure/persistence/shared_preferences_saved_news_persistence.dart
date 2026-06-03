import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/saved_news_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SavedNewsPersistence)
class SharedPreferencesSavedNewsPersistence implements SavedNewsPersistence {
  static const String _savedArticlesKey = 'saved_articles';

  @override
  Future<void> saveArticle(NewsArticle article) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<NewsArticle> articles = await getSavedArticles();

    final bool exists = articles.any(
      (NewsArticle a) => a.urlSource == article.urlSource,
    );

    if (!exists) {
      articles.insert(0, article);
      final List<String> encoded = articles
          .map((NewsArticle a) => jsonEncode(a.toJson()))
          .toList();
      await prefs.setStringList(_savedArticlesKey, encoded);
    }
  }

  @override
  Future<List<NewsArticle>> getSavedArticles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_savedArticlesKey);

    if (encoded == null) {
      return <NewsArticle>[];
    }

    return encoded.map((String s) {
      final Object? json = jsonDecode(s);
      if (json is Map<String, dynamic>) {
        return NewsArticle.fromJson(json);
      } else {
        throw const FormatException('Invalid article JSON format');
      }
    }).toList();
  }

  @override
  Future<void> deleteArticle(String urlSource) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<NewsArticle> articles = await getSavedArticles();

    articles.removeWhere((NewsArticle a) => a.urlSource == urlSource);

    final List<String> encoded = articles
        .map((NewsArticle a) => jsonEncode(a.toJson()))
        .toList();
    await prefs.setStringList(_savedArticlesKey, encoded);
  }

  @override
  Future<bool> isSaved(String urlSource) async {
    final List<NewsArticle> articles = await getSavedArticles();
    return articles.any((NewsArticle a) => a.urlSource == urlSource);
  }

  @override
  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedArticlesKey);
  }
}
