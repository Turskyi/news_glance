import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/user_interface/line_chart.dart';

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
  final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey();

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            widget.article.description,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText),
          const SizedBox(height: 20.0),
          Center(
            key: _globalKey,
            child: const LineChart(),
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText),
        ],
      ),
    );
  }
}
