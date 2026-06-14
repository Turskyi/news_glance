import 'package:flutter/material.dart';

class BriefingStyleCard extends StatelessWidget {
  const BriefingStyleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.height,
    this.isFeatured = false,
    super.key,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
              fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
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
              margin: const EdgeInsets.only(bottom: 4),
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
