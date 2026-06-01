import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  WebViewController? _controller;
  int _loadingProgress = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final Object? args = ModalRoute.of(context)?.settings.arguments;
      if (args is NewsArticle &&
          args.description.isEmpty &&
          args.articleText.isEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings.
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String link = args is NewsArticle ? args.urlSource : '';
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final WebViewController? controller = _controller;

    final VoidCallback? onUrlTap = link.isEmpty
        ? null
        : () {
            Navigator.pushNamed(
              context,
              AppRoute.articleWeb.path,
              arguments: args,
            );
          };

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
        body:
            args is NewsArticle &&
                args.description.isEmpty &&
                args.articleText.isEmpty &&
                controller != null
            ? Stack(
                children: <Widget>[
                  WebViewWidget(controller: controller),
                  if (_loadingProgress < 100)
                    LinearProgressIndicator(
                      value: _loadingProgress / 100.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              )
            : DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue[50]),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text(
                      args is NewsArticle ? args.description : '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20.0),
                    if (args is NewsArticle && args.imageUrl.isNotEmpty)
                      Center(child: Image.network(args.imageUrl)),
                    if (args is NewsArticle) const SizedBox(height: 20.0),
                    SelectableText(args is NewsArticle ? args.articleText : ''),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: onUrlTap,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            args is NewsArticle ? '${l10n.source}: ' : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(
                                context,
                              ).textTheme.titleLarge?.fontSize,
                            ),
                          ),
                          SelectableText(
                            link,
                            onTap: onUrlTap,
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
