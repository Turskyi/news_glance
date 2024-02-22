// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:news_glance/application_services/repositories/news_repository_impl.dart'
    as _i6;
import 'package:news_glance/di/rest_client_module.dart' as _i7;
import 'package:news_glance/domain_services/news_repository.dart' as _i5;
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart'
    as _i4;
import 'package:news_glance/infrastructure/web_services/rest/logging_interceptor.dart'
    as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt initDependencyInjection({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final restClientModule = _$RestClientModule();
    gh.factory<_i3.LoggingInterceptor>(() => const _i3.LoggingInterceptor());
    gh.factory<_i4.RestClient>(
        () => restClientModule.getRestClient(gh<_i3.LoggingInterceptor>()));
    gh.factory<_i5.NewsRepository>(
        () => _i6.NewsRepositoryImpl(gh<_i4.RestClient>()));
    return this;
  }
}

class _$RestClientModule extends _i7.RestClientModule {}
