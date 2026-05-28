import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/bad_request_exception.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/news_repository.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_response.dart';
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
    String countryCode = constants.internationalCode,
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
  Future<ActionableInsight> getActionableInsight(
    Iterable<NewsArticle> articles, {
    String? lang,
  }) async {
    final ConclusionRequest request = _buildConclusionRequest(
      articles,
      lang: lang,
    );

    try {
      final ActionableInsightResponse response = await _restClient
          .getActionableInsight(request);

      return ActionableInsight(
        conclusion: response.conclusion,
        level: response.level,
        probability: response.probability,
        category: response.category,
      );
    } catch (e) {
      // Fallback to the legacy endpoint
      try {
        final ConclusionResponse fallbackResponse = await _restClient
            .getNewsConclusion(request);
        return ActionableInsight.fromPlainText(fallbackResponse);
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          final Object? errorData = e.response?.data;
          if (errorData is Map<String, Object?>? &&
              errorData != null &&
              errorData.containsKey('error')) {
            final Object? errorMessage = errorData['error'];
            if (errorMessage is String) {
              throw BadRequestException(errorMessage);
            }
          }
          throw Exception(
            'Bad request: Server returned a 400 status code, '
            'but the error message is not in the expected format.',
          );
        } else {
          throw Exception('An error occurred: ${e.message}');
        }
      } catch (e) {
        throw Exception('An unexpected error occurred: $e');
      }
    }
  }

  @override
  Future<String> getNewsConclusion(
    Iterable<NewsArticle> articles, {
    String? lang,
  }) async {
    try {
      final ConclusionResponse response = await _restClient.getNewsConclusion(
        _buildConclusionRequest(articles, lang: lang),
      );
      return response.conclusion;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final Object? errorData = e.response?.data;

        if (errorData is Map<String, Object?>? &&
            errorData != null &&
            errorData.containsKey('error')) {
          final Object? errorMessage = errorData['error'];

          if (errorMessage is String) {
            throw BadRequestException(errorMessage);
          }
        }
        throw Exception(
          'Bad request: Server returned a 400 status code, '
          'but the error message is not in the expected format.',
        );
      } else {
        throw Exception('An error occurred: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  ConclusionRequest _buildConclusionRequest(
    Iterable<NewsArticle> articles, {
    String? lang,
  }) {
    return ConclusionRequest(
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
      lang: lang,
    );
  }
}
