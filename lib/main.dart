import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_event.dart';
import 'package:news_glance/application_services/blocs/search_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/di/injector.dart' as di;
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/news_glance_app.dart';
import 'package:news_glance/res/app_theme.dart';
import 'package:news_glance/router/routes.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Here you should [di.injectDependencies] by a dependency injection framework.
/// The [main] is a dirty low-level module in the outermost circle of the onion
/// architecture.
/// Think of [main] as a plugin to the [NewsGlanceApp] — a plugin that sets up
/// the initial conditions and configurations, gathers all the outside
/// resources, and then hands control over to the high-level policy of the
/// [NewsGlanceApp].
/// When [main] is released, it has utterly no effect on any of the other
/// components in the system. They don’t know about [main], and they don’t care
/// when it changes.
void main() {
  final GetIt dependencies = di.injectDependencies();

  final SettingsBloc settingsBloc = dependencies.get<SettingsBloc>()
    ..add(const LoadSettingsEvent());

  final NewsBloc newsBloc = dependencies.get<NewsBloc>();
  final SearchBloc searchBloc = dependencies.get<SearchBloc>();
  final SavedBriefingsBloc savedBriefingsBloc =
      dependencies.get<SavedBriefingsBloc>()
        ..add(const LoadSavedBriefingsEvent());

  final SavedNewsBloc savedNewsBloc = dependencies.get<SavedNewsBloc>()
    ..add(const LoadSavedNews());

  final AppRouter appRouter = AppRouter(
    newsBloc: newsBloc,
    searchBloc: searchBloc,
    savedBriefingsBloc: savedBriefingsBloc,
    savedNewsBloc: savedNewsBloc,
    settingsBloc: settingsBloc,
    homeWidgetService: dependencies.get<HomeWidgetService>(),
    settingsService: dependencies.get<SettingsService>(),
    persistence: dependencies.get<BriefingPersistence>(),
  );

  runApp(
    NewsGlanceApp(
      routes: appRouter.routeMap,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      settingsBloc: settingsBloc,
      savedBriefingsBloc: savedBriefingsBloc,
      savedNewsBloc: savedNewsBloc,
    ),
  );
}
