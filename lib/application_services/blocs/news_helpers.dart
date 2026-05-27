import 'package:news_glance/domain_models/news_article.dart';

int computeNewsHash(List<NewsArticle> articles) {
  final String joined = articles
      .map((NewsArticle a) => (a.urlSource.isNotEmpty ? a.urlSource : a.title))
      .join('|');
  return joined.hashCode;
}
