import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Markdown preview with limited lines.
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({
    required this.text,
    this.maxLines = 10,
    this.color,
    super.key,
  });

  final String text;
  final int maxLines;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
          color: color ?? Theme.of(context).colorScheme.onSurface,
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
    String html = md.markdownToHtml(markdown);
    // Replace block-level tags with newlines to preserve structure
    String plainText = html
        .replaceAll(RegExp(r'</?(p|h[1-6]|li|br|ul|ol)>'), '\n')
        .replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');

    // Remove remaining HTML tags.
    plainText = plainText.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode common HTML entities
    plainText = plainText
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return plainText.trim();
  }
}
