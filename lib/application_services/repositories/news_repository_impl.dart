import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
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
  Future<String> getNewsConclusion(Iterable<NewsArticle> articles) async {
    try {
      final ConclusionResponse response = await _restClient.getNewsConclusion(
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request specifically.
        final Object? errorData = e.response?.data;

        if (errorData is Map<String, Object?>? &&
            errorData != null &&
            errorData.containsKey('error')) {
          final Object? errorMessage = errorData['error'];

          if (errorMessage is String) {
            // Throw the custom exception.
            throw BadRequestException(errorMessage);
          }
        }
        throw Exception(
          'Bad request: Server returned a 400 status code, '
          'but the error message is not in the expected format.',
        );
      } else {
        // Handle other DioExceptions.
        throw Exception('An error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions.
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
