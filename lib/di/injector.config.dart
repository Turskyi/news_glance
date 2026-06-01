// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:news_glance/application_services/blocs/news_bloc.dart' as _i347;
import 'package:news_glance/application_services/blocs/search_bloc.dart'
    as _i998;
import 'package:news_glance/application_services/home_widget_service_impl.dart'
    as _i854;
import 'package:news_glance/application_services/repositories/news_repository_impl.dart'
    as _i491;
import 'package:news_glance/application_services/settings_bloc.dart' as _i196;
import 'package:news_glance/application_services/settings_service.dart'
    as _i473;
import 'package:news_glance/application_services/sharing_service_impl.dart'
    as _i610;
import 'package:news_glance/di/rest_client_module.dart' as _i108;
import 'package:news_glance/domain_services/briefing_persistence.dart'
    as _i1009;
import 'package:news_glance/domain_services/home_widget_service.dart' as _i182;
import 'package:news_glance/domain_services/news_repository.dart' as _i875;
import 'package:news_glance/domain_services/search_persistence.dart' as _i457;
import 'package:news_glance/domain_services/settings_persistence.dart' as _i300;
import 'package:news_glance/domain_services/sharing_service.dart' as _i0;
import 'package:news_glance/domain_services/use_cases/compute_news_checksum.dart'
    as _i200;
import 'package:news_glance/domain_services/use_cases/compute_search_briefing_checksum.dart'
    as _i985;
import 'package:news_glance/infrastructure/persistence/shared_preferences_briefing_persistence.dart'
    as _i378;
import 'package:news_glance/infrastructure/persistence/shared_preferences_search_persistence.dart'
    as _i614;
import 'package:news_glance/infrastructure/persistence/shared_preferences_settings_persistence.dart'
    as _i1014;
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
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final restClientModule = _$RestClientModule();
    gh.factory<_i200.ComputeNewsChecksum>(() => _i200.ComputeNewsChecksum());
    gh.factory<_i985.ComputeSearchBriefingChecksum>(
      () => _i985.ComputeSearchBriefingChecksum(),
    );
    gh.factory<_i890.LoggingInterceptor>(
      () => const _i890.LoggingInterceptor(),
    );
    gh.lazySingleton<_i300.SettingsPersistence>(
      () => _i1014.SharedPreferencesSettingsPersistence(),
    );
    gh.lazySingleton<_i0.SharingService>(() => _i610.SharingServiceImpl());
    gh.lazySingleton<_i182.HomeWidgetService>(
      () => const _i854.HomeWidgetServiceImpl(),
    );
    gh.lazySingleton<_i457.SearchPersistence>(
      () => _i614.SharedPreferencesSearchPersistence(),
    );
    gh.lazySingleton<_i1009.BriefingPersistence>(
      () => _i378.SharedPreferencesBriefingPersistence(),
    );
    gh.factory<_i979.RestClient>(
      () => restClientModule.getRestClient(gh<_i890.LoggingInterceptor>()),
    );
    gh.factory<_i473.SettingsService>(
      () => _i473.SettingsService(
        gh<_i300.SettingsPersistence>(),
        gh<_i182.HomeWidgetService>(),
      ),
    );
    gh.factory<_i196.SettingsBloc>(
      () => _i196.SettingsBloc(gh<_i473.SettingsService>()),
    );
    gh.factory<_i875.NewsRepository>(
      () => _i491.NewsRepositoryImpl(gh<_i979.RestClient>()),
    );
    gh.factory<_i998.SearchBloc>(
      () => _i998.SearchBloc(
        gh<_i875.NewsRepository>(),
        gh<_i457.SearchPersistence>(),
        gh<_i1009.BriefingPersistence>(),
        gh<_i985.ComputeSearchBriefingChecksum>(),
        gh<_i473.SettingsService>(),
      ),
    );
    gh.factory<_i347.NewsBloc>(
      () => _i347.NewsBloc(
        gh<_i875.NewsRepository>(),
        gh<_i0.SharingService>(),
        gh<_i200.ComputeNewsChecksum>(),
        gh<_i1009.BriefingPersistence>(),
        gh<_i473.SettingsService>(),
      ),
    );
    return this;
  }
}

class _$RestClientModule extends _i108.RestClientModule {}
