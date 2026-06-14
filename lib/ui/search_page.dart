import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/search_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/news_article_list.dart';
import 'package:news_glance/ui/search/recent_searches_list.dart';
import 'package:news_glance/ui/search/search_briefing_section.dart';
import 'package:news_glance/ui/search/search_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(const LoadSearchHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations? l10n = AppLocalizations.of(context);

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
          title: Text(
            l10n?.searchNews ?? 'Search News',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (BuildContext context, SearchState state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SearchField(
                              controller: _searchController,
                              onSubmitted: _onSearchSubmitted,
                            ),
                            if (state is SearchInitialState &&
                                state.recentSearches.isNotEmpty)
                              RecentSearchesList(
                                searches: state.recentSearches,
                                onTap: _onRecentSearchSelected,
                              ),
                            if (state is SearchLoadingState)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 32.0,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            if (state is SearchResultsLoadedState) ...<Widget>[
                              if (state.articles.isEmpty &&
                                  state.errorMessage == null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      l10n?.noResultsFound ??
                                          'No results found.',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            if (state is SearchErrorState)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 32.0,
                                ),
                                child: Center(
                                  child: Text(
                                    state.errorMessage,
                                    style: TextStyle(
                                      color: colorScheme.onPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is SearchResultsLoadedState)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: SearchBriefingSection(state: state),
                    ),
                  ),
                if (state is SearchResultsLoadedState &&
                    state.articles.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: NewsArticleList(news: state.articles),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onRecentSearchSelected(String query) {
    _searchController.text = query;
    _onSearchSubmitted(query);
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchBloc>().add(PerformSearchEvent(query));
    }
  }
}
