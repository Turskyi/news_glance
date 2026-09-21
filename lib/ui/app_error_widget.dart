import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.onRetry,
    required this.errorMessage,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations? l10n = AppLocalizations.of(context);

    String displayMessage = errorMessage;

    final String currentErrorMessage = errorMessage;
    if (l10n != null) {
      if (currentErrorMessage ==
          'Connection timed out. Please try again later.') {
        displayMessage = l10n.connectionTimedOut;
      } else if (currentErrorMessage ==
          'No internet connection. Please check your network settings.') {
        displayMessage = l10n.noInternetConnectionSettings;
      } else if (currentErrorMessage == 'An unexpected error occurred.') {
        displayMessage = l10n.unexpectedErrorOccurred;
      } else if (currentErrorMessage.startsWith('Network error: ')) {
        final String details = currentErrorMessage.substring(
          'Network error: '.length,
        );
        displayMessage = l10n.networkErrorPrefix(details);
      }
    }

    final String whatYouCanDoText = l10n?.whatYouCanDo ?? 'What you can do:';
    final String checkInternetText =
        l10n?.checkInternetConnection ?? 'Check your internet connection.';
    final String tryAgainText =
        l10n?.tryAgainButton ?? 'Try again using the button below.';
    final String comeBackText =
        l10n?.comeBackTomorrow ??
        'Come back tomorrow if the server is undergoing '
            'maintenance.';
    final String contactSupportText =
        l10n?.contactSupport(constants.email) ??
        'Contact support at ${constants.email}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: constants.maxContentWidth,
          ),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colorScheme.error.withValues(alpha: 0.3),
                spreadRadius: 4,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 48.0,
              ),
              const SizedBox(height: 16.0),
              SelectableText(
                displayMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$whatYouCanDoText\n'
                  '• $checkInternetText\n'
                  '• $tryAgainText\n'
                  '• $comeBackText\n'
                  '• $contactSupportText',
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
              ...<Widget>[
                const SizedBox(height: 24.0),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n?.retry ?? 'Retry'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
