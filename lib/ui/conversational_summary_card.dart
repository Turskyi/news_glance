import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class ConversationalSummaryCard extends StatelessWidget {
  const ConversationalSummaryCard({required this.summary, super.key});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text('👋', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n?.conversationalSummary ?? 'Summary',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white),
                onPressed: () => _speak(context, summary),
                tooltip: l10n?.readAloud,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
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
              p: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
              h1: const TextStyle(color: Colors.white, fontSize: 22),
              h2: const TextStyle(color: Colors.white, fontSize: 20),
              h3: const TextStyle(color: Colors.white, fontSize: 18),
              listBullet: const TextStyle(color: Colors.white),
              strong: const TextStyle(
                color: Colors.white,
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
    final String ttsLanguage = languageCode == 'uk' ? 'uk-UA' : 'en-US';
    await flutterTts.setLanguage(ttsLanguage);
    await flutterTts.speak(text);
  }
}
