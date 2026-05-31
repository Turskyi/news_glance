import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({required this.appName, required this.version, super.key});

  final String appName;
  final String version;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.blue, Colors.indigo, Colors.purple],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Chewy',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n?.tagline ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n?.version(version) ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
