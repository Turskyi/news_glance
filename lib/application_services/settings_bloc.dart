import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';

import 'settings_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState(ConclusionUiStyle.insight)) {
    on<LoadSettingsEvent>(_onLoad);
    on<SetConclusionStyleEvent>(_onSetStyle);
  }

  final SettingsService _service = SettingsService();

  Future<void> _onLoad(LoadSettingsEvent _, Emitter<SettingsState> emit) async {
    final ConclusionUiStyle style = await _service.getConclusionUiStyle();
    emit(SettingsState(style));
  }

  Future<void> _onSetStyle(
    SetConclusionStyleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _service.setConclusionUiStyle(event.style);
    emit(SettingsState(event.style));
  }
}
