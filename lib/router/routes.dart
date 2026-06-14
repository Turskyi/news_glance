import 'package:flutter/material.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/blocs/search_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/domain_services/sharing_service.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/router/home_route_wrapper.dart';
import 'package:news_glance/router/saved_briefings_route_wrapper.dart';
import 'package:news_glance/router/saved_news_route_wrapper.dart';
import 'package:news_glance/router/search_route_wrapper.dart';
import 'package:news_glance/ui/about/about_page.dart';
import 'package:news_glance/ui/article_screen.dart';
import 'package:news_glance/ui/article_web_screen.dart';
import 'package:news_glance/ui/onboarding/onboarding_screen.dart';

class AppRouter {
  const AppRouter({
    required this.newsBloc,
    required this.searchBloc,
    required this.savedBriefingsBloc,
    required this.savedNewsBloc,
    required this.settingsBloc,
    required this.homeWidgetService,
    required this.settingsService,
    required this.persistence,
    required this.sharingService,
  });

  final NewsBloc newsBloc;
  final SearchBloc searchBloc;
  final SavedBriefingsBloc savedBriefingsBloc;
  final SavedNewsBloc savedNewsBloc;
  final SettingsBloc settingsBloc;
  final HomeWidgetService homeWidgetService;
  final SettingsService settingsService;
  final BriefingPersistence persistence;
  final SharingService sharingService;

  Map<String, WidgetBuilder> get routeMap => <String, WidgetBuilder>{
    AppRoute.home.path: (BuildContext _) => HomeRouteWrapper(
      newsBloc: newsBloc,
      settingsBloc: settingsBloc,
      savedBriefingsBloc: savedBriefingsBloc,
      homeWidgetService: homeWidgetService,
      settingsService: settingsService,
      persistence: persistence,
    ),
    AppRoute.article.path: (BuildContext _) =>
        ArticleScreen(sharingService: sharingService),
    AppRoute.articleWeb.path: (BuildContext _) => const ArticleWebScreen(),
    AppRoute.about.path: (BuildContext _) => const AboutPage(),
    AppRoute.onboarding.path: (BuildContext _) => const OnboardingScreen(),
    AppRoute.search.path: (BuildContext _) => SearchRouteWrapper(
      searchBloc: searchBloc,
      settingsBloc: settingsBloc,
      savedBriefingsBloc: savedBriefingsBloc,
    ),
    AppRoute.savedBriefings.path: (BuildContext _) =>
        SavedBriefingsRouteWrapper(
          savedBriefingsBloc: savedBriefingsBloc,
          settingsBloc: settingsBloc,
        ),
    AppRoute.savedArticles.path: (BuildContext _) => SavedNewsRouteWrapper(
      savedNewsBloc: savedNewsBloc,
      settingsBloc: settingsBloc,
    ),
  };
}
