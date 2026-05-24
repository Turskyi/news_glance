import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/ui/end_drawer.dart';
import 'package:news_glance/ui/markdown_preview.dart';
import 'package:news_glance/ui/news_article_list.dart';

import 'app_error_widget.dart';
import 'empty_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const EndDrawer(),
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: _blocListener,
          builder: (BuildContext context, NewsState state) {
            if (state is LoadedNewsState) {
              return Semantics(
                label: 'Home screen with the title on top, and the list of '
                    'headlines of article news titles below.',
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: MediaQuery.paddingOf(context).top,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'News Glance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.fontSize,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      Scaffold.of(context).openEndDrawer(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) =>
                                  FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                              child: (state is LoadedConclusionState &&
                                      state.conclusion.trim().isNotEmpty)
                                  ? LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        final String plainText =
                                            MarkdownPreview.getPlainText(
                                                state.conclusion);
                                        final TextPainter textPainter =
                                            TextPainter(
                                          text: TextSpan(
                                            text: plainText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          maxLines: 5,
                                          textDirection: TextDirection.ltr,
                                        )..layout(
                                                maxWidth: constraints.maxWidth);

                                        final bool hasOverflow =
                                            textPainter.didExceedMaxLines;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            MarkdownPreview(
                                              text: state.conclusion.trim(),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                if (hasOverflow)
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        _showFullConclusionDialog(
                                                      context,
                                                      state.conclusion,
                                                    ),
                                                    child:
                                                        const Text('Read More'),
                                                  )
                                                else
                                                  const SizedBox.shrink(),
                                                //TODO: fix for iOS, does not
                                                // make a sound
                                                if (kIsWeb ||
                                                    Platform.isAndroid)
                                                  ElevatedButton(
                                                    onPressed: () => _speak(
                                                      state.conclusion,
                                                    ),
                                                    child: const Text(
                                                        'Read Aloud'),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    state.news.isEmpty
                        ? const EmptyNewsWidget()
                        : NewsArticleList(news: state.news),
                  ],
                ),
              );
            } else if (state is ErrorState) {
              return AppErrorWidget(
                errorMessage: state.errorMessage,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, NewsState state) {
    if (state is NewsConclusionError) {
      _showErrorSnackBar(
        context: context,
        errorMessage: state.errorMessage,
      );
    }
  }

  void _showErrorSnackBar({
    required BuildContext context,
    required String errorMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  Future<void> _speak(String text) async {
    final FlutterTts flutterTts = FlutterTts();
    if (!kIsWeb) {
      if (Platform.isIOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          <IosTextToSpeechAudioCategoryOptions>[
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }
    }

    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _showFullConclusionDialog(BuildContext context, String conclusion) {
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
                const Text(
                  'Conclusion',
                  style: TextStyle(
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
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
