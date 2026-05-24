import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/ui/end_drawer.dart';
import 'package:news_glance/ui/news_article_list.dart';
import 'package:news_glance/ui/news_conclusion_section.dart';

import 'app_error_widget.dart';
import 'empty_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
            if (state is LoadedNewsState) {
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
                                  'News Glance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.displaySmall?.fontSize,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      Scaffold.of(context).openEndDrawer(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            NewsConclusionSection(
                              conclusion: state is LoadedConclusionState
                                  ? state.conclusion
                                  : '',
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
