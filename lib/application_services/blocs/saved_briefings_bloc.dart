import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_models/saved_briefing.dart';
import 'package:news_glance/domain_services/saved_briefing_persistence.dart';
import 'package:news_glance/domain_services/sharing_service.dart';

part 'saved_briefings_event.dart';
part 'saved_briefings_state.dart';

@injectable
class SavedBriefingsBloc
    extends Bloc<SavedBriefingsEvent, SavedBriefingsState> {
  SavedBriefingsBloc(this._persistence, this._sharingService)
    : super(const SavedBriefingsLoading()) {
    on<LoadSavedBriefingsEvent>(_onLoad);
    on<SaveBriefingEvent>(_onSave);
    on<DeleteSavedBriefingEvent>(_onDelete);
    on<ShareSavedBriefingEvent>(_onShare);
  }

  final SavedBriefingPersistence _persistence;
  final SharingService _sharingService;

  FutureOr<void> _onLoad(
    LoadSavedBriefingsEvent event,
    Emitter<SavedBriefingsState> emit,
  ) async {
    emit(const SavedBriefingsLoading());
    try {
      final List<SavedBriefing> briefings = await _persistence
          .getSavedBriefings();
      emit(SavedBriefingsLoaded(briefings: briefings));
    } catch (e) {
      emit(SavedBriefingError(e.toString()));
    }
  }

  FutureOr<void> _onSave(
    SaveBriefingEvent event,
    Emitter<SavedBriefingsState> emit,
  ) async {
    try {
      final SavedBriefing briefing = SavedBriefing.fromActionableInsight(
        insight: event.insight,
        type: event.type,
        searchQuery: event.searchQuery,
      );
      await _persistence.saveBriefing(briefing);

      final List<SavedBriefing> briefings = await _persistence
          .getSavedBriefings();
      emit(
        SavedBriefingsLoaded(briefings: briefings, lastSavedId: briefing.id),
      );
    } catch (e) {
      emit(SavedBriefingError(e.toString()));
    }
  }

  FutureOr<void> _onDelete(
    DeleteSavedBriefingEvent event,
    Emitter<SavedBriefingsState> emit,
  ) async {
    try {
      await _persistence.deleteBriefing(event.id);
      final List<SavedBriefing> briefings = await _persistence
          .getSavedBriefings();
      emit(SavedBriefingsLoaded(briefings: briefings));
    } catch (e) {
      emit(SavedBriefingError(e.toString()));
    }
  }

  FutureOr<void> _onShare(
    ShareSavedBriefingEvent event,
    Emitter<SavedBriefingsState> emit,
  ) async {
    await _sharingService.shareBriefing(event.briefing.conclusion);
  }
}
