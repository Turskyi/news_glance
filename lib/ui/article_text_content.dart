import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/news_article.dart';

class ArticleTextContent extends StatelessWidget {
  const ArticleTextContent({
    required this.article,
    required this.isExpanded,
    super.key,
  });

  final NewsArticle article;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          article.title,
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
            fontSize: isExpanded ? 18 : 14,
            height: 1.2,
          ),
          maxLines: isExpanded ? 3 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          article.description,
          style: TextStyle(
            color: Colors.blue[800]?.withValues(alpha: 0.8),
            fontSize: isExpanded ? 13 : 12,
          ),
          maxLines: isExpanded ? 3 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (isExpanded && article.articleText.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              article.articleText,
              style: TextStyle(
                color: Colors.blue[800]?.withValues(alpha: 0.5),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
            ),
          ),
        ],
      ],
    );
  }
}
