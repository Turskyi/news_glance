import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/article_screen.dart';
import 'package:news_glance/ui/article_web_screen.dart';
import 'package:news_glance/ui/home_page.dart';

Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
  AppRoute.home.path: (BuildContext _) => BlocProvider<NewsBloc>(
    create: (BuildContext _) {
      return GetIt.I.get<NewsBloc>()..add(const LoadNewsEvent());
    },
    child: const BlocListener<NewsBloc, NewsState>(
      listener: _handleNewsStateChange,
      child: HomePage(),
    ),
  ),
  AppRoute.article.path: (_) => const ArticleScreen(),
  AppRoute.articleWeb.path: (_) => const ArticleWebScreen(),
};

void _handleNewsStateChange(BuildContext _, NewsState state) {
  if (state.canUpdateHomeWidget && state is LoadedConclusionState) {
    _updateHomeWidgetConclusion(state.conclusion);
  }
}

void _updateHomeWidgetConclusion(String conclusion) {
  // Set the group ID
  HomeWidget.setAppGroupId(constants.appGroupId);
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>(
    'headline_title',
    'News Glance from ${DateTime.now().toString().substring(0, 10)}',
  );
  if (conclusion.isNotEmpty) {
    HomeWidget.saveWidgetData<String>('headline_description', conclusion);
  }
  HomeWidget.updateWidget(
    iOSName: constants.iOSWidgetName,
    androidName: constants.androidWidgetName,
  );
}
