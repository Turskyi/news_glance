import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_event.dart';
import 'package:news_glance/application_services/blocs/saved_news_state.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({required this.article, super.key});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return BlocBuilder<SavedNewsBloc, SavedNewsState>(
      builder: (BuildContext context, SavedNewsState state) {
        final bool isSaved =
            state is SavedNewsLoaded &&
            state.articles.any(
              (NewsArticle a) => a.urlSource == article.urlSource,
            );

        return IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isSaved ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: () {
            context.read<SavedNewsBloc>().add(
              ToggleSaveArticle(article: article),
            );
            ScaffoldMessenger.of(context).clearSnackBars();
            if (l10n != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? l10n.articleRemoved : l10n.articleSaved,
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }
}
