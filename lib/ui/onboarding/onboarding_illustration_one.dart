import 'package:flutter/material.dart';

class OnboardingIllustrationOne extends StatelessWidget {
  const OnboardingIllustrationOne({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Background news cards (smaller and faded)
            _PositionedNewsCard(
              top: 20,
              left: 20,
              rotation: -0.2,
              color: colorScheme.surfaceContainerHighest,
              opacity: 0.4,
            ),
            _PositionedNewsCard(
              top: 40,
              right: 20,
              rotation: 0.15,
              color: colorScheme.surfaceContainerHighest,
              opacity: 0.6,
            ),
            _PositionedNewsCard(
              bottom: 60,
              left: 40,
              rotation: -0.1,
              color: colorScheme.surfaceContainerHighest,
              opacity: 0.5,
            ),

            // Main AI card in the center
            Container(
              width: 180,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.auto_awesome,
                      color: colorScheme.onPrimary,
                      size: 32,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 140,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 120,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.bolt,
                        color: colorScheme.onPrimary.withValues(alpha: 0.8),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PositionedNewsCard extends StatelessWidget {
  const _PositionedNewsCard({
    required this.color,
    required this.opacity,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.rotation = 0,
  });

  final Color color;
  final double opacity;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 6,
                  color: color.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 4,
                  color: color.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 4,
                  color: color.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
