import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/sharing_service.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/article_image.dart';
import 'package:news_glance/ui/bookmark_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({required this.sharingService, super.key});

  final SharingService sharingService;

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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

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
                        colorScheme.primary,
                      ),
                    ),
                ],
              )
            : DecoratedBox(
                decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
                child: SelectionArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: maxContentWidth,
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: <Widget>[
                          if (args is NewsArticle &&
                              args.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                args.description,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (args is NewsArticle && args.imageUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: ArticleImage(imageUrl: args.imageUrl),
                            ),
                          if (args is NewsArticle &&
                              args.articleText.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                args.articleText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          if (args is NewsArticle)
                            _SourceSection(
                              link: link,
                              title: args.title,
                              onUrlTap: onUrlTap,
                              sharingService: widget.sharingService,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({
    required this.link,
    required this.title,
    required this.onUrlTap,
    required this.sharingService,
  });

  final String link;
  final String title;
  final VoidCallback? onUrlTap;
  final SharingService sharingService;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onUrlTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${l10n.source}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.titleLarge?.fontSize,
                  ),
                ),
                Text(
                  link,
                  style: TextStyle(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: <Widget>[
            _ArticleActionButton(
              icon: Icons.open_in_new,
              label: l10n.open,
              onPressed: onUrlTap,
            ),
            _ArticleActionButton(
              icon: Icons.copy,
              label: l10n.copyLink,
              onPressed: () {
                sharingService.copyToClipboard(link);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.linkCopiedToClipboard),
                    behavior: SnackBarBehavior.floating,
                    width: 300,
                  ),
                );
              },
            ),
            _ArticleActionButton(
              icon: Icons.share,
              label: l10n.share,
              onPressed: () {
                sharingService.shareUrl(link, title: title);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ArticleActionButton extends StatelessWidget {
  const _ArticleActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
