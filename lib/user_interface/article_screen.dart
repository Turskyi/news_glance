import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/user_interface/line_chart.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    super.key,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is NewsArticle) {}
    return Scaffold(
      appBar: AppBar(
        title: Text(args is NewsArticle ? args.title : ''),
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
            args is NewsArticle ? args.description : '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text(args is NewsArticle ? args.articleText : ''),
          const SizedBox(height: 20.0),
          Center(
            key: _globalKey,
            child: const LineChart(),
          ),
          const SizedBox(height: 20.0),
          Text(args is NewsArticle ? args.articleText : ''),
        ],
      ),
    );
  }
}
