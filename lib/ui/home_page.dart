import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/conversational_summary_card.dart';
import 'package:news_glance/ui/end_drawer.dart';
import 'package:news_glance/ui/news_article_list.dart';
import 'package:news_glance/ui/news_conclusion_section.dart';
import 'package:news_glance/ui/refresh_button.dart';
import 'package:news_glance/ui/signal_card.dart';

import 'app_error_widget.dart';
import 'empty_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: MediaQuery.paddingOf(context).top,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  l10n?.appName ?? 'News Glance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.displaySmall?.fontSize,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const RefreshButton(),
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
                                }

                                return switch (style) {
                                  ConclusionUiStyle.conclusion =>
                                    NewsConclusionSection(
                                      conclusion: state.insight.conclusion,
                                      textColor: Colors.white,
                                    ),
                                  ConclusionUiStyle.insight => SignalCard(
                                    insight: state.insight,
                                  ),
                                  ConclusionUiStyle.summary =>
                                    ConversationalSummaryCard(
                                      summary: state.insight.conclusion,
                                    ),
                                };
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    state.news.isEmpty
                        ? const EmptyNewsWidget()
                        : NewsArticleList(news: state.news),
                  ],
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

  void _blocListener(BuildContext context, NewsState state) {
    if (state is NewsConclusionError) {
      _showErrorSnackBar(context: context, errorMessage: state.errorMessage);
    }
  }

  void _showErrorSnackBar({
    required BuildContext context,
    required String errorMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
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
