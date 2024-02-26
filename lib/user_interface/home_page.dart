import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (BuildContext context, NewsState state) {
          if (state is LoadedNewsState) {
            TextStyle style = TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            );
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: state is LoadedConclusionState &&
                          state.conclusion.isNotEmpty
                      ? _calculateExpandedHeight(
                          conclusion: state.conclusion,
                          availableWidth: MediaQuery.sizeOf(context).width,
                          style: style,
                        )
                      : kToolbarHeight + 20,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 44,
                        right: 20,
                        bottom: state is LoadedConclusionState ? 20 : 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'News Glance',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                            ),
                          ),
                          if (state is LoadedConclusionState &&
                              state.conclusion.isNotEmpty)
                            Text(
                              state.conclusion,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: style,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final NewsArticle article = state.news[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            key: Key('$index ${article.hashCode}'),
                            title: Text(article.title),
                            subtitle: article.description.isEmpty
                                ? const SizedBox()
                                : Text(article.description),
                            onTap: () async {
                              // When the user taps the button,
                              // navigate to a named route and
                              // provide the arguments as an optional
                              // parameter.
                              Navigator.pushNamed(
                                context,
                                AppRoute.article.path,
                                arguments: article,
                              );
                            },
                          ),
                          state.news.length - 1 == index
                              ? const SizedBox()
                              : const Divider(),
                        ],
                      );
                    },
                    childCount: state.news.length,
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  double _calculateExpandedHeight({
    required String conclusion,
    required double availableWidth,
    required TextStyle style,
  }) {
    const double defaultExpandedHeight = 200.0;
    const double adjustment = 68.0;
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: conclusion,
        style: style,
      ),
      maxLines: 100,
      textDirection: TextDirection.ltr,
    );

    // Use the actual available width for layout
    textPainter.layout(maxWidth: availableWidth);

    // Calculate the number of lines based on the actual available width
    int numberOfLines = (textPainter.size.height / style.fontSize!).ceil();
    double expandedHeight =
        defaultExpandedHeight + numberOfLines * style.fontSize! - adjustment;

    return expandedHeight;
  }
}
