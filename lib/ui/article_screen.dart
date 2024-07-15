import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  WebViewController? _controller;

  @override
  void didChangeDependencies() {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is NewsArticle &&
        args.description.isEmpty &&
        args.articleText.isEmpty) {
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
    String link = args is NewsArticle ? args.urlSource : '';
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
            // color: Colors.black,
          ),
        ),
        body: args is NewsArticle &&
                args.description.isEmpty &&
                args.articleText.isEmpty &&
                _controller != null
            ? WebViewWidget(controller: _controller!)
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text(
                      args is NewsArticle ? args.description : '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20.0),
                    if (args is NewsArticle && args.imageUrl.isNotEmpty)
                      Center(
                        child: Image.network(args.imageUrl),
                      ),
                    if (args is NewsArticle) const SizedBox(height: 20.0),
                    Text(args is NewsArticle ? args.articleText : ''),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: link.isEmpty
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.articleWeb.path,
                                arguments: args,
                              );
                            },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            args is NewsArticle ? 'Source: ' : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                            ),
                          ),
                          Text(
                            args is NewsArticle ? args.urlSource : '',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
