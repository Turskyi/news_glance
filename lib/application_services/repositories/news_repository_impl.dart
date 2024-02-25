import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/country_code.dart' as country;
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/infrastructure/web_services/models/conclusion_response/conclusion_response.dart';
import 'package:news_glance/infrastructure/web_services/models/news_article_response/news_article_response.dart';
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<List<NewsArticle>> getNews({
    String countryCode = country.canadaCode,
  }) async {
    final List<NewsArticle> articles = <NewsArticle>[];
    final List<NewsArticleResponse> response =
        await _restClient.getNews(countryCode: countryCode);
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

  @override
  Future<String> getNewsConclusion(String prompt) async {
    String encodedPrompt = Uri.encodeComponent(prompt);
    final ConclusionResponse response =
        await _restClient.getNewsConclusion(encodedPrompt);
    return response.conclusion;
  }
}
