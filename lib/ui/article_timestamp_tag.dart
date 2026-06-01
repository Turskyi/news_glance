import 'package:flutter/material.dart';
import 'package:news_glance/ui/time_ago_formatter.dart';

class ArticleTimestampTag extends StatelessWidget {
  const ArticleTimestampTag({
    required this.publishedAt,
    this.isFloating = true,
    super.key,
  });

  final DateTime publishedAt;
  final bool isFloating;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFloating
            ? Colors.black.withValues(alpha: 0.6)
            : colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: isFloating ? Colors.white : colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            formatTimeAgo(publishedAt),
            style: TextStyle(
              color: isFloating ? Colors.white : colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
