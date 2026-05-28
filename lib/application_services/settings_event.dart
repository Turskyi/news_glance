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

  final Locale locale;
}
