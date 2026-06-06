import 'package:flutter/material.dart';

class ArticleImage extends StatefulWidget {
  const ArticleImage({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  State<ArticleImage> createState() => _ArticleImageState();
}

class _ArticleImageState extends State<ArticleImage> {
  bool _hasError = false;

  @override
  void didUpdateWidget(covariant ArticleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: (_hasError || widget.imageUrl.isEmpty)
          ? const SizedBox.shrink()
          : AspectRatio(
              aspectRatio: 1.7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder:
                        (
                          BuildContext _,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            final ColorScheme colorScheme = Theme.of(
                              context,
                            ).colorScheme;
                            final int? totalBytes =
                                loadingProgress.expectedTotalBytes;
                            final double? value = totalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      totalBytes
                                : null;

                            return Container(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.1),
                              child: Center(
                                child: SizedBox(
                                  width: 40,
                                  child: LinearProgressIndicator(
                                    value: value,
                                    backgroundColor: colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted && !_hasError) {
                              setState(() {
                                _hasError = true;
                              });
                            }
                          });
                          return const SizedBox.shrink();
                        },
                  ),
                ),
              ),
            ),
    );
  }
}
