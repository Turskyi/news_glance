import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/saved_briefing.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class SaveBriefingButton extends StatelessWidget {
  const SaveBriefingButton({
    required this.insight,
    required this.type,
    this.searchQuery,
    this.color,
    super.key,
  });

  final ActionableInsight insight;
  final ConclusionUiStyle type;
  final String? searchQuery;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final Color effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return BlocBuilder<SavedBriefingsBloc, SavedBriefingsState>(
      builder: (BuildContext context, SavedBriefingsState state) {
        final bool isSaved =
            state is SavedBriefingsLoaded &&
            state.briefings.any(
              (SavedBriefing b) =>
                  b.conclusion == insight.conclusion && b.type == type,
            );

        return IconButton(
          icon: Icon(
            isSaved ? Icons.star : Icons.star_border,
            color: effectiveColor,
          ),
          onPressed: isSaved
              ? null
              : () {
                  context.read<SavedBriefingsBloc>().add(
                    SaveBriefingEvent(
                      insight: insight,
                      type: type,
                      searchQuery: searchQuery,
                    ),
                  );
                  _showFeedback(context, l10n);
                },
          tooltip: isSaved
              ? l10n?.briefingSaved ?? 'Saved'
              : l10n?.saveBriefing ?? 'Save briefing',
        );
      },
    );
  }

  void _showFeedback(BuildContext context, AppLocalizations? l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.briefingSaved ?? 'Insight saved'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
