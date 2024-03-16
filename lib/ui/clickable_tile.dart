import 'package:flutter/material.dart';

class ClickableTile extends StatelessWidget {
  const ClickableTile({super.key, required this.onTap, required this.title});

  /// Called when the user taps this list tile.
  final GestureTapCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          color: Colors.blue,
        ),
      ),
      onTap: onTap,
    );
  }
}
