import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/about/about_card.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return AboutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n?.howItWorks ?? '',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStep(context, icon: Icons.public, text: l10n?.step1 ?? ''),
          const SizedBox(height: 12),
          _buildStep(
            context,
            icon: Icons.analytics_outlined,
            text: l10n?.step2 ?? '',
          ),
          const SizedBox(height: 12),
          _buildStep(
            context,
            icon: Icons.chat_bubble_outline,
            text: l10n?.step3 ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
