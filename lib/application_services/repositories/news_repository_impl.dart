import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/infrastructure/web_services/models/news_article_response/news_article_response.dart';
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<List<NewsArticle>> getNews() async {
    final List<NewsArticle> articles = <NewsArticle>[];
    final List<NewsArticleResponse> response = await _restClient.getNews();
    for (NewsArticleResponse article in response) {
      articles.add(
        NewsArticle(
          title: article.title,
          description: article.description,
          imageUrl: article.urlToImage,
          articleText: article.content,
          urlSource: article.url,
        ),
      );
    }
    return articles;
  }
}
