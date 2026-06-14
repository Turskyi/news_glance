part of 'saved_briefings_bloc.dart';

sealed class SavedBriefingsState {
  const SavedBriefingsState();
}

class SavedBriefingsLoading extends SavedBriefingsState {
  const SavedBriefingsLoading();
}

class SavedBriefingsLoaded extends SavedBriefingsState {
  const SavedBriefingsLoaded({required this.briefings, this.lastSavedId});

  final List<SavedBriefing> briefings;
  final String? lastSavedId;
}

class SavedBriefingError extends SavedBriefingsState {
  const SavedBriefingError(this.message);

  final String message;
}
