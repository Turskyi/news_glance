import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_state.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/ui/news_article_list_tile.dart';
import 'package:news_glance/ui/saved_news/empty_saved_news_widget.dart';

class SavedNewsScreen extends StatelessWidget {
  const SavedNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n?.savedArticles ?? 'Saved Articles',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: constants.maxContentWidth,
            ),
            child: BlocBuilder<SavedNewsBloc, SavedNewsState>(
              builder: (BuildContext _, SavedNewsState state) {
                if (state is SavedNewsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (state is SavedNewsLoaded) {
                  if (state.articles.isEmpty) {
                    return const EmptySavedNewsWidget();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                        left: 8,
                        right: 8,
                      ),
                      itemCount: state.articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NewsArticleListTile(
                          article: state.articles[index],
                        );
                      },
                    );
                  }
                } else if (state is SavedNewsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
