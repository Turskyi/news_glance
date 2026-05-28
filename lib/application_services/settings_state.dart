part of 'settings_bloc.dart';

@immutable
class SettingsState {
  const SettingsState({
    required this.style,
    required this.locale,
    this.isLoaded = false,
  });

  final ConclusionUiStyle style;
  final Locale locale;
  final bool isLoaded;
}
