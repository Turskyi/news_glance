import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class EmptyNewsWidget extends StatelessWidget {
  const EmptyNewsWidget({this.onRefresh, super.key});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final VoidCallback? refreshCallback = onRefresh;

    return SliverFillRemaining(
      child: Center(
        child: Card(
          // Add a shadow.
          elevation: 4,
          // Add some margin around the card.
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            // Rounded corners.
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              // Wrap content tightly.
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.info_outline, size: 64, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.noNewsFound,
                  style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pleaseCheckBackLater,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (refreshCallback != null) ...<Widget>[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: refreshCallback,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.refresh),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
