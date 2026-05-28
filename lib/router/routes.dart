import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/home_widget_service_impl.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/article_screen.dart';
import 'package:news_glance/ui/article_web_screen.dart';
import 'package:news_glance/ui/home_page.dart';

class AppRouter {
  const AppRouter({required this._newsBloc, required this._settingsBloc});

  final NewsBloc _newsBloc;
  final SettingsBloc _settingsBloc;

  Map<String, WidgetBuilder> get routeMap => <String, WidgetBuilder>{
    AppRoute.home.path: (BuildContext _) => MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<NewsBloc>.value(value: _newsBloc),
        BlocProvider<SettingsBloc>.value(value: _settingsBloc),
      ],
      child: MultiBlocListener(
        listeners: <SingleChildWidget>[
          const BlocListener<NewsBloc, NewsState>(
            listener: _handleNewsStateChange,
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: _hasLocaleChanged,
            listener: (BuildContext context, SettingsState state) {
              _newsBloc.add(const LoadNewsEvent());
            },
          ),
        ],
        child: const HomePage(),
      ),
    ),
    AppRoute.article.path: (BuildContext _) => const ArticleScreen(),
    AppRoute.articleWeb.path: (BuildContext _) => const ArticleWebScreen(),
  };

  bool _hasLocaleChanged(SettingsState previous, SettingsState current) {
    return previous.locale != current.locale;
  }

  static void _handleNewsStateChange(BuildContext _, NewsState state) {
    if (state.canUpdateHomeWidget && state is LoadedConclusionState) {
      _updateHomeWidgetConclusion(state.insight);
    }
  }

  static Future<void> _updateHomeWidgetConclusion(
    ActionableInsight insight,
  ) async {
    const HomeWidgetService homeWidgetService = HomeWidgetServiceImpl();
    final SettingsService settingsService = SettingsService();
    final ConclusionUiStyle style = await settingsService
        .getConclusionUiStyle();

    if (style == ConclusionUiStyle.conclusion) {
      final String title = insight.conclusion.split('\n').first;
      await homeWidgetService.updateHomeWidget(
        headlineTitle: title,
        headlineDescription: insight.conclusion,
      );
    } else {
      await homeWidgetService.updateHomeWidgetWithSignal(insight: insight);
    }
  }
}
