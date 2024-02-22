import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/res/constants.dart';
import 'package:news_glance/user_interface/article_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Set the group ID
    HomeWidget.setAppGroupId(appGroupId);

    // Mock read in some data and update the headline
    final NewsArticle newHeadline = _getNewsStories()[0];
    _updateHeadline(newHeadline);
  }

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
        itemCount: _getNewsStories().length,
        itemBuilder: (BuildContext context, int idx) {
          final NewsArticle article = _getNewsStories()[idx];
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

  List<NewsArticle> _getNewsStories() {
    return <NewsArticle>[
      const NewsArticle(
        title: 'Flutter DAU surpasses 10 billion',
        description:
            'There are more Flutter users than there are human beings. What '
            'gives?',
        imageUrl: '',
      ),
      const NewsArticle(
        title: 'Remembering Flutter Forward',
        description:
            'Flutter Forward took place in Nairobi, Kenya in January 2023',
        imageUrl: '',
      ),
      const NewsArticle(
        title: 'Flutter Community saves world',
        description: "They're just that nice",
        imageUrl: '',
      ),
      const NewsArticle(
        title: 'Flutter DAU surpasses 10 billion',
        description:
            'There are more Flutter users than there are human beings. What '
            'gives?',
        imageUrl: '',
      ),
    ];
  }

  void _updateHeadline(NewsArticle newHeadline) {
    // Save the headline data to the widget
    HomeWidget.saveWidgetData<String>('headline_title', newHeadline.title);
    HomeWidget.saveWidgetData<String>(
      'headline_description',
      newHeadline.description,
    );
    HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }
}
