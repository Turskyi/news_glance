import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/res/constants.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/user_interface/article_screen.dart';
import 'package:news_glance/user_interface/article_web_screen.dart';
import 'package:news_glance/user_interface/home_page.dart';

Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
  AppRoute.home.path: (_) => BlocProvider<NewsBloc>(
        create: (_) => GetIt.I.get<NewsBloc>()..add(const LoadNewsEvent()),
        child: BlocListener<NewsBloc, NewsState>(
          listener: (BuildContext context, NewsState state) {
            if (state is LoadedConclusionState && state.conclusion.isNotEmpty) {
              _updateHeadline(state.conclusion);
            }
          },
          child: const HomePage(),
        ),
      ),
  AppRoute.article.path: (_) => const ArticleScreen(),
  AppRoute.articleWeb.path: (_) => const ArticleWebScreen(),
};

void _updateHeadline(String conclusion) {
  // Set the group ID
  HomeWidget.setAppGroupId(appGroupId);
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>('headline_title', 'News Glance');
  if (conclusion.isNotEmpty) {
    HomeWidget.saveWidgetData<String>(
      'headline_description',
      conclusion,
    );
  }
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}
