import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/article_text_content.dart';
import 'package:news_glance/ui/article_timestamp_tag.dart';

class NewsArticleGridTile extends StatefulWidget {
  const NewsArticleGridTile({required this.article, super.key});

  final NewsArticle article;

  @override
  State<NewsArticleGridTile> createState() => _NewsArticleGridTileState();
}

class _NewsArticleGridTileState extends State<NewsArticleGridTile> {
  bool _imageError = false;

  @override
  Widget build(BuildContext context) {
    final bool showImage = widget.article.imageUrl.isNotEmpty && !_imageError;

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoute.article.path,
            arguments: widget.article,
          ),
          child: showImage
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(
                            widget.article.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) {
                                      setState(() => _imageError = true);
                                    }
                                  });
                                  return const SizedBox.shrink();
                                },
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: ArticleTimestampTag(
                              publishedAt: widget.article.publishedAt,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ArticleTextContent(
                        article: widget.article,
                        isExpanded: false,
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ArticleTimestampTag(
                        publishedAt: widget.article.publishedAt,
                        isFloating: false,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ArticleTextContent(
                          article: widget.article,
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
