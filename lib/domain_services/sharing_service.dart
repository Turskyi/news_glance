import 'package:meta/meta.dart';

@immutable
abstract interface class SharingService {
  /// Shares the given text using the platform-native share sheet.
  /// If sharing is unavailable, falls back to copying to clipboard.
  /// Returns a [SharingResult] indicating the outcome.
  Future<SharingResult> shareBriefing(String text);
}

enum SharingResult { shared, copiedToClipboard, failed }
