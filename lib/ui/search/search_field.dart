import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText:
                l10n?.searchPlaceholder ?? 'e.g. Technology, AI, Space...',
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            labelText: l10n?.searchQueryLabel ?? 'Enter your search query',
            labelStyle: textTheme.labelMedium?.copyWith(color: Colors.white),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: controller.clear,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => onSubmitted(controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n?.searchButtonText ?? 'Search',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
