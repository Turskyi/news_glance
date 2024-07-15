import 'package:flutter/material.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/router/routes.dart' as routes;

class NewsGlanceApp extends StatelessWidget {
  const NewsGlanceApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Glance',
      initialRoute: AppRoute.home.path,
      routes: routes.routeMap,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.blue,
          secondary: Colors.purple,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .primaryContainer,
          // This changes the color of AppBar icons.
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Chewy',
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
