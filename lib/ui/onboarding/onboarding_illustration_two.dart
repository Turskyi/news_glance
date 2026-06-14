import 'package:flutter/material.dart';

class OnboardingIllustrationTwo extends StatelessWidget {
  const OnboardingIllustrationTwo({super.key});

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
            // Network lines (using a custom painter or just stacked containers)
            CustomPaint(
              size: const Size(260, 260),
              painter: _NetworkPainter(color: colorScheme.primaryContainer),
            ),

            // Distributed news items
            _NewsNode(
              top: 40,
              left: 30,
              icon: Icons.public,
              color: colorScheme.surfaceContainerHighest,
            ),
            _NewsNode(
              top: 20,
              right: 60,
              icon: Icons.language,
              color: colorScheme.surfaceContainerHighest,
            ),
            _NewsNode(
              bottom: 80,
              left: 20,
              icon: Icons.newspaper,
              color: colorScheme.surfaceContainerHighest,
            ),
            _NewsNode(
              bottom: 30,
              right: 40,
              icon: Icons.article,
              color: colorScheme.surfaceContainerHighest,
            ),

            // Central Insight Node
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[colorScheme.primary, colorScheme.secondary],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.insights,
                color: colorScheme.onPrimary,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsNode extends StatelessWidget {
  const _NewsNode({
    required this.icon,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final IconData icon;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw lines from nodes to center
    canvas.drawLine(const Offset(40, 50), center, paint);
    canvas.drawLine(Offset(size.width - 70, 30), center, paint);
    canvas.drawLine(Offset(30, size.height - 90), center, paint);
    canvas.drawLine(Offset(size.width - 50, size.height - 40), center, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
