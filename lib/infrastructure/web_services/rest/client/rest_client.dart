import 'package:dio/dio.dart';
import 'package:news_glance/domain_models/country_code.dart' as country;
import 'package:news_glance/infrastructure/web_services/models/conclusion_response/conclusion_response.dart';
import 'package:news_glance/infrastructure/web_services/models/news_article_response/news_article_response.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('news')
  Future<List<NewsArticleResponse>> getNews({
    @Query('country') String countryCode = country.canadaCode,
  });

  @GET('news-conclusion')
  Future<ConclusionResponse> getNewsConclusion(
    @Query('prompt') String prompt,
  );
}
