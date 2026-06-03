import 'package:flutter/material.dart';

class OnboardingIllustrationThree extends StatelessWidget {
  const OnboardingIllustrationThree({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SizedBox(
        height: 300,
        width: 320,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _BriefingStyleCard(
              title: 'Insight',
              icon: Icons.lightbulb_outline,
              color: colorScheme.primary,
              height: 180,
            ),
            _BriefingStyleCard(
              title: 'Conclusion',
              icon: Icons.assignment_turned_in_outlined,
              color: colorScheme.secondary,
              height: 220, // Middle one is taller for emphasis
              isFeatured: true,
            ),
            _BriefingStyleCard(
              title: 'Summary',
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

class _BriefingStyleCard extends StatelessWidget {
  const _BriefingStyleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.height,
    this.isFeatured = false,
  });

  final String title;
  final IconData icon;
  final Color color;
  final double height;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 90,
      height: height,
      decoration: BoxDecoration(
        color: isFeatured ? color : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isFeatured
            ? <BoxShadow>[
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: isFeatured ? colorScheme.onPrimary : color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isFeatured
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Skeleton text
          for (int i = 0; i < 3; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: (isFeatured ? colorScheme.onPrimary : color).withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
