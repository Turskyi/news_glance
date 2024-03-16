import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebScreen extends StatefulWidget {
  const ArticleWebScreen({super.key});

  @override
  State<ArticleWebScreen> createState() => _ArticleWebScreenState();
}

class _ArticleWebScreenState extends State<ArticleWebScreen> {
  late WebViewController _controller;

  @override
  void didChangeDependencies() {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is NewsArticle) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              //TODO: Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(args.urlSource));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings.
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Colors.blue, Colors.indigo, Colors.purple],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(args is NewsArticle ? args.title : ''),
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue[50],
          ),
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
