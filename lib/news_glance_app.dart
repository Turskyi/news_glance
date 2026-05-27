import 'package:flutter/material.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';

class NewsGlanceApp extends StatelessWidget {
  const NewsGlanceApp({required this._routes, required this._theme, super.key});

  final Map<String, WidgetBuilder> _routes;
  final ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: constants.appName,
      initialRoute: AppRoute.home.path,
      routes: _routes,
      theme: _theme,
    );
  }
}
