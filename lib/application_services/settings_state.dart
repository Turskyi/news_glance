part of 'settings_bloc.dart';

@immutable
class SettingsState {
  const SettingsState({
    required this.style,
    required this.locale,
    this.themeMode = ThemeMode.system,
    this.isLoaded = false,
    this.isOnboardingCompleted = false,
  });

  final ConclusionUiStyle style;
  final AppLocale locale;
  final ThemeMode themeMode;
  final bool isLoaded;
  final bool isOnboardingCompleted;
}
