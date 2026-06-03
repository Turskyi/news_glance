import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;

class OnboardingNavigationBar extends StatelessWidget {
  const OnboardingNavigationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final bool isLastPage = currentPage == totalPages - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: constants.maxContentWidth,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Skip Button
                Opacity(
                  opacity: isLastPage ? 0.0 : 1.0,
                  child: TextButton(
                    onPressed: isLastPage ? null : onSkip,
                    child: Text(l10n?.skip ?? 'Skip'),
                  ),
                ),

                // Page Indicator
                Row(
                  children: List<Widget>.generate(
                    totalPages,
                    (int index) =>
                        _PageIndicator(isActive: index == currentPage),
                  ),
                ),

                // Next / Get Started Button
                if (isLastPage)
                  FilledButton(
                    onPressed: onNext,
                    child: Text(l10n?.getStarted ?? 'Get Started'),
                  )
                else
                  IconButton.filled(
                    onPressed: onNext,
                    icon: const Icon(Icons.chevron_right),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
