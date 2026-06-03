import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/saved_briefing.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/markdown_preview.dart';

class SavedBriefingCard extends StatelessWidget {
  const SavedBriefingCard({required this.briefing, super.key});

  final SavedBriefing briefing;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String formattedDate = DateFormat.yMMMd().add_Hm().format(
      briefing.savedAt,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          leading: _buildTypeIcon(briefing.type),
          title: Text(
            _getTypeLabel(l10n, briefing),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MarkdownPreview(
                    text: briefing.conclusion,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {
                          context.read<SavedBriefingsBloc>().add(
                            ShareSavedBriefingEvent(briefing),
                          );
                        },
                        tooltip: l10n?.shareBriefing,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _confirmDelete(context, l10n),
                        tooltip: l10n?.delete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(ConclusionUiStyle type) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Text(switch (type) {
        ConclusionUiStyle.insight => '💡',
        ConclusionUiStyle.conclusion => '🎯',
        ConclusionUiStyle.summary => '📝',
      }, style: const TextStyle(fontSize: 20)),
    );
  }

  String _getTypeLabel(AppLocalizations? l10n, SavedBriefing briefing) {
    final String baseLabel = switch (briefing.type) {
      ConclusionUiStyle.insight => l10n?.insight ?? 'Insight',
      ConclusionUiStyle.conclusion => l10n?.conclusion ?? 'Conclusion',
      ConclusionUiStyle.summary => l10n?.summary ?? 'Summary',
    };

    if (briefing.searchQuery != null) {
      return '$baseLabel: ${briefing.searchQuery}';
    }
    return baseLabel;
  }

  void _confirmDelete(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n?.delete ?? 'Delete'),
          content: Text(
            l10n?.confirmDelete ?? 'Are you sure you want to delete this?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<SavedBriefingsBloc>().add(
                  DeleteSavedBriefingEvent(briefing.id),
                );
                Navigator.of(context).pop();
              },
              child: Text(
                l10n?.delete ?? 'Delete',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
