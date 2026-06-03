import 'package:news_glance/domain_models/saved_briefing.dart';

abstract interface class SavedBriefingPersistence {
  const SavedBriefingPersistence();

  Future<void> saveBriefing(SavedBriefing briefing);

  Future<List<SavedBriefing>> getSavedBriefings();

  Future<void> deleteBriefing(String id);

  Future<void> clearAll();
}
