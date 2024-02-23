import 'package:flutter/material.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/user_interface/article_screen.dart';
import 'package:news_glance/user_interface/home_page.dart';

class NewsGlanceApp extends StatelessWidget {
  const NewsGlanceApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Glance',
      initialRoute: AppRoute.home.path,
      routes: <String, WidgetBuilder>{
        AppRoute.home.path: (_) => const HomePage(),
        AppRoute.article.path: (_) => const ArticleScreen(),
      },
      theme: ThemeData(
        // This is the theme of the application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .primaryContainer,
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Chewy',
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
