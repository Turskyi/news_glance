import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/markdown_preview.dart';

class NewsConclusionSection extends StatelessWidget {
  const NewsConclusionSection({
    required this.conclusion,
    this.textColor,
    super.key,
  });

  final String conclusion;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SizedBox.shrink();
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: conclusion.trim().isNotEmpty
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final String plainText = MarkdownPreview.getPlainText(
                    conclusion,
                  );
                  final TextPainter textPainter = TextPainter(
                    text: TextSpan(
                      text: plainText,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: effectiveColor),
                    ),
                    maxLines: 5,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);

                  final bool hasOverflow = textPainter.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MarkdownPreview(
                        text: conclusion.trim(),
                        color: effectiveColor,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          if (hasOverflow) ...<Widget>[
                            ElevatedButton(
                              onPressed: () => _showFullConclusionDialog(
                                context,
                                conclusion,
                              ),
                              child: Text(l10n.readMore),
                            ),
                            const SizedBox(width: 8),
                          ],
                          ElevatedButton(
                            onPressed: () => _speak(context, conclusion),
                            child: Text(l10n.readAloud),
                          ),
                          const Spacer(),
                          Tooltip(
                            message: l10n.shareBriefing,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<NewsBloc>().add(
                                  ShareBriefingEvent(conclusion),
                                );
                              },
                              icon: const Icon(Icons.share, size: 18),
                              label: Text(l10n.shareBriefing),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            : const SizedBox(),
      );
    }
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
      } else {
        // No special configuration needed for other platforms.
      }
    } else {
      // Web uses browser's native TTS configuration.
    }

    final String ttsLanguage = languageCode == 'uk' ? 'uk-UA' : 'en-US';

    await flutterTts.setLanguage(ttsLanguage);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _showFullConclusionDialog(BuildContext context, String conclusion) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.conclusion,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: MarkdownBody(
                      selectable: true,
                      data: conclusion.trim(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.close),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
