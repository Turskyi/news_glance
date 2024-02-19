import 'package:flutter/material.dart';
import 'package:news_glance/article_screen.dart';
import 'package:news_glance/news_article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Glance'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int idx) {
          return const Divider();
        },
        itemCount: getNewsStories().length,
        itemBuilder: (BuildContext context, int idx) {
          final NewsArticle article = getNewsStories()[idx];
          return ListTile(
            key: Key('$idx ${article.hashCode}'),
            title: Text(article.title),
            subtitle: Text(article.description),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<ArticleScreen>(
                  builder: (BuildContext context) {
                    return ArticleScreen(article: article);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<NewsArticle> getNewsStories() {
    return <NewsArticle>[
      const NewsArticle(
        title: 'Flutter DAU surpasses 10 billion',
        description:
            'There are more Flutter users than there are human beings. What '
            'gives?',
      ),
      const NewsArticle(
        title: 'Remembering Flutter Forward',
        description:
            'Flutter Forward took place in Nairobi, Kenya in January 2023',
      ),
      const NewsArticle(
        title: 'Flutter Community saves world',
        description: "They're just that nice",
      ),
      const NewsArticle(
        title: 'Flutter DAU surpasses 10 billion',
        description:
            'There are more Flutter users than there are human beings. What '
            'gives?',
      ),
    ];
  }
}
