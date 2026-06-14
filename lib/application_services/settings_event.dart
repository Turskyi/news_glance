part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class SetConclusionStyleEvent extends SettingsEvent {
  const SetConclusionStyleEvent(this.style);

  final ConclusionUiStyle style;
}

class SetLocaleEvent extends SettingsEvent {
  const SetLocaleEvent(this.locale);

  final AppLocale locale;
}

class SettingsThemeChanged extends SettingsEvent {
  const SettingsThemeChanged(this.themeMode);

  final ThemeMode themeMode;
}

class SetOnboardingCompletedEvent extends SettingsEvent {
  const SetOnboardingCompletedEvent({required this.completed});

  final bool completed;
}

class SetWidgetUpdateFrequencyEvent extends SettingsEvent {
  const SetWidgetUpdateFrequencyEvent(this.frequency);

  final int frequency;
}
