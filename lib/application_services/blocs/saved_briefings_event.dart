part of 'saved_briefings_bloc.dart';

sealed class SavedBriefingsEvent {
  const SavedBriefingsEvent();
}

class LoadSavedBriefingsEvent extends SavedBriefingsEvent {
  const LoadSavedBriefingsEvent();
}

class SaveBriefingEvent extends SavedBriefingsEvent {
  const SaveBriefingEvent({
    required this.insight,
    required this.type,
    this.searchQuery,
  });

  final ActionableInsight insight;
  final ConclusionUiStyle type;
  final String? searchQuery;
}

class DeleteSavedBriefingEvent extends SavedBriefingsEvent {
  const DeleteSavedBriefingEvent(this.id);

  final String id;
}

class ShareSavedBriefingEvent extends SavedBriefingsEvent {
  const ShareSavedBriefingEvent(this.briefing);

  final SavedBriefing briefing;
}
