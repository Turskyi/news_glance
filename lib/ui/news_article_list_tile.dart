import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/bookmark_button.dart';
import 'package:news_glance/ui/time_ago_formatter.dart';

class NewsArticleListTile extends StatefulWidget {
  const NewsArticleListTile({required this.article, super.key});

  final NewsArticle article;

  @override
  State<NewsArticleListTile> createState() => _NewsArticleListTileState();
}

class _NewsArticleListTileState extends State<NewsArticleListTile> {
  bool _imageError = false;

  @override
  Widget build(BuildContext context) {
    final bool showImage = widget.article.imageUrl.isNotEmpty && !_imageError;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: showImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.article.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => _imageError = true);
                            }
                          });
                          return const SizedBox.shrink();
                        },
                  ),
                )
              : null,
          title: Text(
            widget.article.title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.article.description,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatTimeAgo(widget.article.publishedAt),
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BookmarkButton(article: widget.article),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.outline,
                size: 24,
              ),
            ],
          ),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoute.article.path,
            arguments: widget.article,
          ),
        ),
      ),
    );
  }
}
