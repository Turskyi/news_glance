import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:markdown/markdown.dart' as md;

/// Markdown preview with limited lines.
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: constants.defaultExpandedHeight,
      ),
      child: SizedBox(
        height: 144,
        child: Markdown(
          data: _getMarkdownPreview(
            text,
          ),
          styleSheet: MarkdownStyleSheet(
            p: style.copyWith(
              color: Colors.white,
            ),
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }

  String _getMarkdownPreview(String markdown) {
    // Strip Markdown to plain text for preview with ellipsis.
    String plainText = md.markdownToHtml(markdown);
    // Remove HTML tags.
    plainText = plainText.replaceAll(RegExp(r'<[^>]*>'), '');
    const int previewLength = 120;
    if (plainText.length > previewLength) {
      // Limit preview length.
      return '${plainText.substring(0, previewLength)}...';
    }
    return plainText;
  }
}
