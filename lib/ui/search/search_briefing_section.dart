import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/search_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/ui/conversational_summary_card.dart';
import 'package:news_glance/ui/news_conclusion_section.dart';
import 'package:news_glance/ui/signal_card.dart';

class SearchBriefingSection extends StatelessWidget {
  const SearchBriefingSection({required this.state, super.key});

  final SearchResultsLoadedState state;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (state.insight == null &&
        state.errorMessage == null &&
        state.articles.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          state.errorMessage!,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else {
      final ActionableInsight? insight = state.insight;
      if (insight == null) {
        return const SizedBox.shrink();
      } else {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext _, SettingsState settingsState) {
            final ConclusionUiStyle style = settingsState.style;
            return switch (style) {
              ConclusionUiStyle.conclusion => NewsConclusionSection(
                insight: insight,
                searchQuery: state.query,
                textColor: Colors.white,
              ),
              ConclusionUiStyle.insight => SignalCard(
                insight: insight,
                searchQuery: state.query,
              ),
              ConclusionUiStyle.summary => ConversationalSummaryCard(
                insight: insight,
                searchQuery: state.query,
              ),
            };
          },
        );
      }
    }
  }
}
