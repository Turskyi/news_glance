import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/home_page.dart';
import 'package:news_glance/line_chart.dart';
import 'package:news_glance/news_article.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    super.key,
    required this.article,
  });

  final NewsArticle article;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _globalKey = GlobalKey();
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_globalKey.currentContext != null) {
            dynamic path = await HomeWidget.renderFlutterWidget(
              const LineChart(),
              key: 'filename',
              logicalSize: _globalKey.currentContext?.size ?? Size.zero,
              pixelRatio:
              MediaQuery.of(_globalKey.currentContext!).devicePixelRatio,
            );
            setState(() {
              imagePath = path as String?;
            });
          }
          updateHeadline(widget.article);
        },
        label: const Text('Update Home-screen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            widget.article.description,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText!),
          const SizedBox(height: 20.0),
          Center(
            key: _globalKey,
            child: const LineChart(),
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText!),
        ],
      ),
    );
  }
}
