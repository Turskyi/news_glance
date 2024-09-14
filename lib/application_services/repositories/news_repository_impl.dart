import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/infrastructure/web_services/models/conclusion_request/article_request.dart';
import 'package:news_glance/infrastructure/web_services/models/conclusion_request/conclusion_request.dart';
import 'package:news_glance/infrastructure/web_services/models/conclusion_response/conclusion_response.dart';
import 'package:news_glance/infrastructure/web_services/models/news_article_response/news_article_response.dart';
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart';
import 'package:news_glance/res/constants.dart' as constants;

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<List<NewsArticle>> getNews({
    String countryCode = constants.usaCode,
  }) async {
    final List<NewsArticle> articles = <NewsArticle>[];
    final List<NewsArticleResponse> response = await _restClient.getNews(
      countryCode: countryCode,
    );
    for (final NewsArticleResponse article in response) {
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

  @override
  Future<String> getNewsConclusion(List<NewsArticle> articles) async {
    final ConclusionResponse response = await _restClient.getConclusion(
      ConclusionRequest(
        articles: articles
            .take(constants.newsMax)
            .map(
              (NewsArticle article) => ArticleRequest(
                title: article.title,
                description: article.description,
                articleText: article.articleText,
              ),
            )
            .toList(),
      ),
    );
    return response.conclusion;
  }
}
