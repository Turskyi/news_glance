import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';

import 'settings_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._service, this._homeWidgetService)
    : super(
        const SettingsState(
          style: ConclusionUiStyle.insight,
          locale: AppLocale.english,
        ),
      ) {
    on<LoadSettingsEvent>(_onLoad);
    on<SetConclusionStyleEvent>(_onSetStyle);
    on<SetLocaleEvent>(_onSetLocale);
    on<SettingsThemeChanged>(_onSetThemeMode);
    on<SetOnboardingCompletedEvent>(_onSetOnboardingCompleted);
    on<SetWidgetUpdateFrequencyEvent>(_onSetWidgetUpdateFrequency);
  }

  final SettingsService _service;
  final HomeWidgetService _homeWidgetService;

  Future<void> _onLoad(LoadSettingsEvent _, Emitter<SettingsState> emit) async {
    debugPrint('SettingsBloc: [_onLoad] started');
    final ConclusionUiStyle style = await _service.getConclusionUiStyle();
    final AppLocale locale = await _service.getLocale();
    final ThemeMode themeMode = await _service.getThemeMode();
    final bool isOnboardingCompleted = await _service.isOnboardingCompleted();
    final int frequency = await _homeWidgetService.getWidgetUpdateFrequency();
    debugPrint(
      'SettingsBloc: [_onLoad] settings fetched, emitting isLoaded: true',
    );
    emit(
      SettingsState(
        style: style,
        locale: locale,
        themeMode: themeMode,
        isOnboardingCompleted: isOnboardingCompleted,
        widgetUpdateFrequency: frequency,
        isLoaded: true,
      ),
    );
  }

  Future<void> _onSetStyle(
    SetConclusionStyleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _service.setConclusionUiStyle(event.style);
    emit(
      SettingsState(
        style: event.style,
        locale: state.locale,
        themeMode: state.themeMode,
        isOnboardingCompleted: state.isOnboardingCompleted,
        widgetUpdateFrequency: state.widgetUpdateFrequency,
        isLoaded: state.isLoaded,
      ),
    );
  }

  Future<void> _onSetLocale(
    SetLocaleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _service.setLocale(event.locale);
    emit(
      SettingsState(
        style: state.style,
        locale: event.locale,
        themeMode: state.themeMode,
        isOnboardingCompleted: state.isOnboardingCompleted,
        widgetUpdateFrequency: state.widgetUpdateFrequency,
        isLoaded: state.isLoaded,
      ),
    );
  }

  Future<void> _onSetThemeMode(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _service.setThemeMode(event.themeMode);
    emit(
      SettingsState(
        style: state.style,
        locale: state.locale,
        themeMode: event.themeMode,
        isOnboardingCompleted: state.isOnboardingCompleted,
        widgetUpdateFrequency: state.widgetUpdateFrequency,
        isLoaded: state.isLoaded,
      ),
    );
  }

  Future<void> _onSetOnboardingCompleted(
    SetOnboardingCompletedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _service.setOnboardingCompleted(event.completed);
    emit(
      SettingsState(
        style: state.style,
        locale: state.locale,
        themeMode: state.themeMode,
        isOnboardingCompleted: event.completed,
        widgetUpdateFrequency: state.widgetUpdateFrequency,
        isLoaded: state.isLoaded,
      ),
    );
  }

  Future<void> _onSetWidgetUpdateFrequency(
    SetWidgetUpdateFrequencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _homeWidgetService.setWidgetUpdateFrequency(event.frequency);
    emit(
      SettingsState(
        style: state.style,
        locale: state.locale,
        themeMode: state.themeMode,
        isOnboardingCompleted: state.isOnboardingCompleted,
        widgetUpdateFrequency: event.frequency,
        isLoaded: state.isLoaded,
      ),
    );
  }
}
