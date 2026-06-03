import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class EmptySavedNewsWidget extends StatelessWidget {
  const EmptySavedNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.bookmark_border_rounded,
            size: 80,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            l10n?.noSavedArticles ?? 'No saved articles yet.',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.saveArticlesToReadLater ?? 'Save articles to read later.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
