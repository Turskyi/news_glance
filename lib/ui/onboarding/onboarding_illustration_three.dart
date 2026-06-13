import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/onboarding/briefing_style_card.dart';

class OnboardingIllustrationThree extends StatelessWidget {
  const OnboardingIllustrationThree({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SizedBox.shrink();
    } else {
      return Center(
        child: SizedBox(
          height: 300,
          width: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BriefingStyleCard(
                title: l10n.insight,
                icon: Icons.lightbulb_outline,
                color: colorScheme.primary,
                height: 180,
              ),
              BriefingStyleCard(
                title: l10n.conclusion,
                icon: Icons.assignment_turned_in_outlined,
                color: colorScheme.secondary,
                height: 220,
                // Middle one is taller for emphasis
                isFeatured: true,
              ),
              BriefingStyleCard(
                title: l10n.summary,
                icon: Icons.notes,
                color: colorScheme.tertiary,
                height: 180,
              ),
            ],
          ),
        ),
      );
    }
  }
}
