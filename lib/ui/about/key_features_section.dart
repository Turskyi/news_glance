import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class KeyFeaturesSection extends StatelessWidget {
  const KeyFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            l10n?.keyFeatures ?? '',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        _buildFeature(
          context,
          Icons.auto_awesome,
          l10n?.featureAiBriefing ?? '',
        ),
        _buildFeature(
          context,
          Icons.language,
          l10n?.featureGlobalMonitoring ?? '',
        ),
        _buildFeature(
          context,
          Icons.menu_book,
          l10n?.featureReadingExperience ?? '',
        ),
        _buildFeature(
          context,
          Icons.widgets_outlined,
          l10n?.featureHomeWidget ?? '',
        ),
        _buildFeature(
          context,
          Icons.share_outlined,
          l10n?.featureShareableInsights ?? '',
        ),
        _buildFeature(context, Icons.link, l10n?.featureOriginalSources ?? ''),
      ],
    );
  }

  Widget _buildFeature(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
