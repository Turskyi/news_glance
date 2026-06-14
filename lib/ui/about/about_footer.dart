import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class AboutFooter extends StatelessWidget {
  const AboutFooter({required this.appName, required this.version, super.key});

  final String appName;
  final String version;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: <Widget>[
          Text(
            '$appName ${l10n?.version(version) ?? ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n?.copyright(DateTime.now().year, appName) ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
