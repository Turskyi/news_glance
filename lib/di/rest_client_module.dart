import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart';
import 'package:news_glance/infrastructure/web_services/rest/logging_interceptor.dart';
import 'package:news_glance/res/constants.dart' as constants;

@module
abstract class RestClientModule {
  RestClient getRestClient(
    LoggingInterceptor loggingInterceptor,
  ) {
    final Dio dio = Dio();
    dio.interceptors.add(loggingInterceptor);
    return RestClient(dio, baseUrl: constants.baseUrl);
  }
}
