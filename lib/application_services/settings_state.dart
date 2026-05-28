part of 'settings_bloc.dart';

@immutable
class SettingsState {
  const SettingsState({required this.style, required this.locale});

  final ConclusionUiStyle style;
  final Locale locale;
}
