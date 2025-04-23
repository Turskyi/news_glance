import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';

class NewsArticleList extends StatelessWidget {
  const NewsArticleList({required this.news, super.key});

  final List<NewsArticle> news;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: news.length,
        (BuildContext context, int index) {
          final NewsArticle article = news[index];
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.blue.shade100,
                    Colors.purple.shade100,
                  ],
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  right: 8,
                  top: 8,
                  bottom: 8,
                ),
                title: Text(
                  article.title,
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  article.description,
                  style: TextStyle(color: Colors.blue[900]),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.blue[300],
                  size: 20,
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoute.article.path,
                  arguments: article,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
