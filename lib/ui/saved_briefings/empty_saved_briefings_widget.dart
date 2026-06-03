import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class EmptySavedBriefingsWidget extends StatelessWidget {
  const EmptySavedBriefingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.star_border, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            l10n?.noSavedInsights ?? 'No saved insights yet.',
            style: const TextStyle(color: Colors.white54, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
