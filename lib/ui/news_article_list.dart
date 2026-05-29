import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/ui/news_article_grid_tile.dart';
import 'package:news_glance/ui/news_article_list_tile.dart';

class NewsArticleList extends StatelessWidget {
  const NewsArticleList({required this.news, super.key});

  final List<NewsArticle> news;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    if (width > 600) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 450,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return NewsArticleGridTile(article: news[index]);
        }, childCount: news.length),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return NewsArticleListTile(article: news[index]);
        }, childCount: news.length),
      );
    }
  }
}
