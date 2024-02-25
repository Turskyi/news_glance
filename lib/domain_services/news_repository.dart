import 'package:news_glance/domain_models/country_code.dart' as country;
import 'package:news_glance/domain_models/news_article.dart';

abstract class NewsRepository {
  const NewsRepository();

  Future<List<NewsArticle>> getNews({String countryCode = country.canadaCode});

  Future<String> getNewsConclusion(String prompt);
}
