import 'package:flutter/material.dart';

class EmptyNewsWidget extends StatelessWidget {
  const EmptyNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No news available at the moment.',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check back later.',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
