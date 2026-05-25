import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Markdown preview with limited lines.
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({required this.text, this.maxLines = 5, super.key});

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
    );

    return SelectionArea(
      child: Text(
        getPlainText(text),
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static String getPlainText(String markdown) {
    // Strip Markdown to plain text.
    String plainText = md.markdownToHtml(markdown);
    // Remove HTML tags.
    plainText = plainText.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode HTML entities if any (optional, but good for UX)
    // For now, let's keep it simple as it was.
    return plainText.trim();
  }
}
