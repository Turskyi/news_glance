import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';

import 'settings_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._service)
    : super(
        const SettingsState(
          style: ConclusionUiStyle.insight,
          locale: AppLocale.english,
        ),
      ) {
    on<LoadSettingsEvent>(_onLoad);
    on<SetConclusionStyleEvent>(_onSetStyle);
    on<SetLocaleEvent>(_onSetLocale);
  }

  final SettingsService _service;

  Future<void> _onLoad(LoadSettingsEvent _, Emitter<SettingsState> emit) async {
    debugPrint('SettingsBloc: [_onLoad] started');
    final ConclusionUiStyle style = await _service.getConclusionUiStyle();
    final AppLocale locale = await _service.getLocale();
    debugPrint(
      'SettingsBloc: [_onLoad] settings fetched, emitting isLoaded: true',
    );
    emit(SettingsState(style: style, locale: locale, isLoaded: true));
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
        isLoaded: state.isLoaded,
      ),
    );
  }
}
