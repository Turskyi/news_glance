import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/domain_services/sharing_service.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/conversational_summary_card.dart';
import 'package:news_glance/ui/end_drawer.dart';
import 'package:news_glance/ui/news_article_list.dart';
import 'package:news_glance/ui/news_conclusion_section.dart';
import 'package:news_glance/ui/refresh_button.dart';
import 'package:news_glance/ui/signal_card.dart';

import 'app_error_widget.dart';
import 'empty_news_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.persistence, super.key});

  final BriefingPersistence persistence;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const EndDrawer(),
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: _blocListener,
          builder: (BuildContext context, NewsState state) {
            debugPrint('HomePage: [_builder] state is ${state.runtimeType}');
            if (state is LoadedNewsState) {
              debugPrint(
                'HomePage: [_builder] state has ${state.news.length} articles',
              );
              return Semantics(
                label:
                    'Home screen with the title on top, and the list of '
                    'headlines of article news titles below.',
                child: Scrollbar(
                  controller: _scrollController,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: MediaQuery.paddingOf(context).top,
                            right: 20,
                            bottom: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        l10n?.appName ?? 'News Glance',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Theme.of(
                                            context,
                                          ).textTheme.headlineLarge?.fontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      BlocBuilder<SettingsBloc, SettingsState>(
                                        builder:
                                            (
                                              BuildContext _,
                                              SettingsState state,
                                            ) {
                                              return IconButton(
                                                icon: AnimatedSwitcher(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  child: Icon(
                                                    state.themeMode.isSystem
                                                        ? Icons.brightness_auto
                                                        : state.themeMode ==
                                                              ThemeMode.dark
                                                        ? Icons.dark_mode
                                                        : Icons.light_mode,
                                                    key: ValueKey<ThemeMode>(
                                                      state.themeMode,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _cycleThemeMode(
                                                    state.themeMode,
                                                  );
                                                },
                                              );
                                            },
                                      ),
                                      RefreshButton(
                                        persistence: widget.persistence,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        onPressed: _navigateToSearch,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.menu,
                                          color: Colors.white,
                                        ),
                                        onPressed: Scaffold.of(
                                          context,
                                        ).openEndDrawer,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocBuilder<SettingsBloc, SettingsState>(
                                builder: (BuildContext _, SettingsState s) {
                                  final ConclusionUiStyle style = s.style;
                                  if (state is! LoadedConclusionState) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return switch (style) {
                                      ConclusionUiStyle.conclusion =>
                                        NewsConclusionSection(
                                          insight: state.insight,
                                          textColor: Colors.white,
                                        ),
                                      ConclusionUiStyle.insight => SignalCard(
                                        insight: state.insight,
                                      ),
                                      ConclusionUiStyle.summary =>
                                        ConversationalSummaryCard(
                                          insight: state.insight,
                                        ),
                                    };
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      state.news.isEmpty
                          ? EmptyNewsWidget(onRefresh: _loadNews)
                          : SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              sliver: NewsArticleList(news: state.news),
                            ),
                    ],
                  ),
                ),
              );
            } else if (state is ErrorState) {
              return AppErrorWidget(errorMessage: state.errorMessage);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Object?> _navigateToSearch() {
    return Navigator.of(context).pushNamed(AppRoute.search.path);
  }

  void _cycleThemeMode(ThemeMode themeMode) {
    final ThemeMode nextMode = themeMode.isSystem
        ? ThemeMode.light
        : themeMode.isLight
        ? ThemeMode.dark
        : ThemeMode.system;
    return context.read<SettingsBloc>().add(SettingsThemeChanged(nextMode));
  }

  void _loadNews() {
    return context.read<NewsBloc>().add(const LoadNewsEvent());
  }

  void _blocListener(BuildContext context, NewsState state) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (state is NewsConclusionError) {
      _showErrorSnackBar(context: context, errorMessage: state.errorMessage);
    } else if (state is BriefingSharingSuccess && l10n != null) {
      final String message = state.result == SharingResult.shared
          ? l10n.briefingShared
          : l10n.briefingCopiedToClipboard;
      _showSuccessSnackBar(context: context, message: message);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  _showSuccessSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showErrorSnackBar({
    required BuildContext context,
    required String errorMessage,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }
}
