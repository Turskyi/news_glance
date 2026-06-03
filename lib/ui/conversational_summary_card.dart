import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/save_briefing_button.dart';

class ConversationalSummaryCard extends StatelessWidget {
  const ConversationalSummaryCard({
    required this.insight,
    this.searchQuery,
    super.key,
  });

  final ActionableInsight insight;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final String summary = insight.conclusion;
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.2)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text('👋', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n?.conversationalSummary ?? 'Summary',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.volume_up, color: colorScheme.onSurface),
                onPressed: () => _speak(context, summary),
                tooltip: l10n?.readAloud,
              ),
              SaveBriefingButton(
                insight: insight,
                type: ConclusionUiStyle.summary,
                searchQuery: searchQuery,
                color: colorScheme.onSurface,
              ),
              IconButton(
                icon: Icon(Icons.share, color: colorScheme.onSurface),
                onPressed: () {
                  context.read<NewsBloc>().add(ShareBriefingEvent(summary));
                },
                tooltip: l10n?.shareBriefing ?? 'Share briefing',
              ),
            ],
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: summary,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                height: 1.5,
              ),
              h1: TextStyle(color: colorScheme.onSurface, fontSize: 22),
              h2: TextStyle(color: colorScheme.onSurface, fontSize: 20),
              h3: TextStyle(color: colorScheme.onSurface, fontSize: 18),
              listBullet: TextStyle(color: colorScheme.onSurface),
              strong: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _speak(BuildContext context, String text) async {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final FlutterTts flutterTts = FlutterTts();
    if (!kIsWeb) {
      if (Platform.isIOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          <IosTextToSpeechAudioCategoryOptions>[
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }
    }
    final String ttsLanguage = AppLocale.fromLanguageCode(
      languageCode,
    ).ttsLanguage;
    await flutterTts.setLanguage(ttsLanguage);
    await flutterTts.speak(text);
  }
}
