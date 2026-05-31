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
import 'package:news_glance/ui/home_page.dart';

class HomeRouteWrapper extends StatefulWidget {
  const HomeRouteWrapper({
    required this.newsBloc,
    required this.settingsBloc,
    super.key,
  });

  final NewsBloc newsBloc;
  final SettingsBloc settingsBloc;

  @override
  State<HomeRouteWrapper> createState() => _HomeRouteWrapperState();
}

class _HomeRouteWrapperState extends State<HomeRouteWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.settingsBloc.state.isLoaded) {
      debugPrint(
        'HomeRouteWrapper: Settings already loaded, triggering LoadNewsEvent',
      );
      widget.newsBloc.add(const LoadNewsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<NewsBloc>.value(value: widget.newsBloc),
        BlocProvider<SettingsBloc>.value(value: widget.settingsBloc),
      ],
      child: MultiBlocListener(
        listeners: <SingleChildWidget>[
          const BlocListener<NewsBloc, NewsState>(
            listener: _handleNewsStateChange,
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (SettingsState previous, SettingsState current) {
              return (!previous.isLoaded && current.isLoaded) ||
                  (previous.locale != current.locale);
            },
            listener: (BuildContext context, SettingsState state) {
              debugPrint(
                'HomeRouteWrapper: Settings transition/locale change, '
                'triggering LoadNewsEvent',
              );
              widget.newsBloc.add(const LoadNewsEvent());
            },
          ),
        ],
        child: const HomePage(),
      ),
    );
  }

  static void _handleNewsStateChange(BuildContext context, NewsState state) {
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

    if (style.isConclusion) {
      final String? title = insight.conclusion.split('\n').firstOrNull;
      await homeWidgetService.updateHomeWidget(
        headlineTitle: title ?? '',
        headlineDescription: insight.conclusion,
      );
    } else {
      await homeWidgetService.updateHomeWidgetWithSignal(insight: insight);
    }
  }
}
