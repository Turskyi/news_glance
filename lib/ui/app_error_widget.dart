import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    this.errorMessage = 'Something went wrong',
    super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            // Background color.
            color: colorScheme.errorContainer,
            // Rounded corners.
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                // Shadow color.
                color: colorScheme.error.withValues(alpha: 0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow offset
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: colorScheme.onErrorContainer,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
