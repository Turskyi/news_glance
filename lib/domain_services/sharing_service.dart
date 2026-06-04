import 'package:meta/meta.dart';

@immutable
abstract interface class SharingService {
  /// Shares the given text using the platform-native share sheet.
  /// If sharing is unavailable, falls back to copying to clipboard.
  /// Returns a [SharingResult] indicating the outcome.
  Future<SharingResult> shareBriefing(String text);

  /// Shares the given URL with an optional title.
  Future<void> shareUrl(String url, {String? title});

  /// Copies the given text to the platform clipboard.
  Future<void> copyToClipboard(String text);
}

enum SharingResult { shared, copiedToClipboard, failed }
