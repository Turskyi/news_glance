import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(16.0),
    super.key,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(padding: padding, child: child),
    );
  }
}
