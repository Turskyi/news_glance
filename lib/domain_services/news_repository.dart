import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/res/constants.dart' as country;

abstract interface class NewsRepository {
  const NewsRepository();

  Future<List<NewsArticle>> getNews({
    String countryCode = country.internationalCode,
  });

  Future<ActionableInsight> getActionableInsight(
    Iterable<NewsArticle> articles,
  );

  Future<String> getNewsConclusion(Iterable<NewsArticle> articles);
}
