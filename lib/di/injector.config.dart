// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:news_glance/application_services/blocs/news_bloc.dart' as _i347;
import 'package:news_glance/application_services/repositories/news_repository_impl.dart'
    as _i491;
import 'package:news_glance/di/rest_client_module.dart' as _i108;
import 'package:news_glance/domain_services/news_repository.dart' as _i875;
import 'package:news_glance/infrastructure/web_services/rest/client/rest_client.dart'
    as _i979;
import 'package:news_glance/infrastructure/web_services/rest/logging_interceptor.dart'
    as _i890;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initDependencyInjection({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final restClientModule = _$RestClientModule();
    gh.factory<_i890.LoggingInterceptor>(
        () => const _i890.LoggingInterceptor());
    gh.factory<_i979.RestClient>(
        () => restClientModule.getRestClient(gh<_i890.LoggingInterceptor>()));
    gh.factory<_i875.NewsRepository>(
        () => _i491.NewsRepositoryImpl(gh<_i979.RestClient>()));
    gh.factory<_i347.NewsBloc>(
        () => _i347.NewsBloc(gh<_i875.NewsRepository>()));
    return this;
  }
}

class _$RestClientModule extends _i108.RestClientModule {}
