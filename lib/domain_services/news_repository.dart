import 'package:news_glance/domain_models/news_article.dart';

abstract class NewsRepository {
  const NewsRepository();

  Future<List<NewsArticle>> getNews();
}
