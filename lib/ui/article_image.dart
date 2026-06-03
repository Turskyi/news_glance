import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AspectRatio(
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
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  final int? totalBytes = loadingProgress.expectedTotalBytes;
                  final double? value = totalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / totalBytes
                      : null;

                  return Container(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.1,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const SizedBox.shrink();
                },
          ),
        ),
      ),
    );
  }
}
