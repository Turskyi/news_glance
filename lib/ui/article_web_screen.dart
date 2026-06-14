import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/ui/bookmark_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebScreen extends StatefulWidget {
  const ArticleWebScreen({super.key});

  @override
  State<ArticleWebScreen> createState() => _ArticleWebScreenState();
}

class _ArticleWebScreenState extends State<ArticleWebScreen> {
  WebViewController? _controller;
  int _loadingProgress = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) {
      return;
    }
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is NewsArticle) {
      final WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      if (Theme.of(context).platform != TargetPlatform.macOS) {
        controller.setBackgroundColor(const Color(0x00000000));
      }

      controller
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                _loadingProgress = progress;
              });
            },
            onPageStarted: (String url) {
              setState(() {
                _loadingProgress = 0;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _loadingProgress = 100;
              });
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(args.urlSource));

      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings.
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final WebViewController? controller = _controller;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.secondary,
          ],
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
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: <Widget>[
            if (args is NewsArticle) BookmarkButton(article: args),
          ],
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: controller == null
              ? const SizedBox.shrink()
              : Stack(
                  children: <Widget>[
                    WebViewWidget(controller: controller),
                    if (_loadingProgress < 100)
                      LinearProgressIndicator(
                        value: _loadingProgress / 100.0,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
