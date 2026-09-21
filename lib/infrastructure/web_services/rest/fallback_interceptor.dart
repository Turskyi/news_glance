import 'package:dio/dio.dart';
import 'package:news_glance/res/constants.dart' as constants;

class FallbackInterceptor extends Interceptor {
  const FallbackInterceptor(this._dio);

  final Dio _dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final Object? indexValue = err.requestOptions.extra['fallback_index'];
    final int fallbackIndex = indexValue is int ? indexValue : 0;

    final List<String> fallbacks = <String>[
      constants.baseUrl,
      constants.fallbackUrl1,
      constants.fallbackUrl2,
    ];

    if (fallbackIndex < fallbacks.length - 1) {
      final int nextIndex = fallbackIndex + 1;
      try {
        // Keeping dynamic here as Map<String, Object?> cannot be passed to
        // Dio's `copyWith(extra: ...)` without explicit casting
        // (violating AGENTS.md), because Map<String, dynamic> is required by
        // the framework.
        // Proof:
        // https://pub.dev/documentation/dio/latest/dio/RequestOptions/extra.html
        final Map<String, dynamic> newExtra = Map<String, dynamic>.from(
          err.requestOptions.extra,
        );
        newExtra['fallback_index'] = nextIndex;

        final RequestOptions newOptions = err.requestOptions.copyWith(
          baseUrl: fallbacks[nextIndex],
          extra: newExtra,
        );

        final Response<Object?> response = await _dio.fetch<Object?>(
          newOptions,
        );
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      } catch (e) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
