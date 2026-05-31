import 'package:flutter/material.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/router/home_route_wrapper.dart';
import 'package:news_glance/ui/about/about_page.dart';
import 'package:news_glance/ui/article_screen.dart';
import 'package:news_glance/ui/article_web_screen.dart';

class AppRouter {
  const AppRouter({required this._newsBloc, required this._settingsBloc});

  final NewsBloc _newsBloc;
  final SettingsBloc _settingsBloc;

  Map<String, WidgetBuilder> get routeMap => <String, WidgetBuilder>{
    AppRoute.home.path: (BuildContext _) =>
        HomeRouteWrapper(newsBloc: _newsBloc, settingsBloc: _settingsBloc),
    AppRoute.article.path: (BuildContext _) => const ArticleScreen(),
    AppRoute.articleWeb.path: (BuildContext _) => const ArticleWebScreen(),
    AppRoute.about.path: (BuildContext _) => const AboutPage(),
  };
}
