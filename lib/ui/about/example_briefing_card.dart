import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/about/about_card.dart';

class ExampleBriefingCard extends StatelessWidget {
  const ExampleBriefingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AboutCard(
      color: colorScheme.primaryContainer.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n?.exampleBriefing ?? '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n?.dailyHeadsUp ?? '',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.exampleBriefingContent ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Divider(height: 32),
          Center(
            child: Text(
              l10n?.illustrativeExample ?? '',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
