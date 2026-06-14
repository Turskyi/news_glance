import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/saved_briefing.dart';
import 'package:news_glance/domain_services/saved_briefing_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SavedBriefingPersistence)
class SharedPreferencesSavedBriefingPersistence
    implements SavedBriefingPersistence {
  static const String _savedBriefingsKey = 'saved_briefings';

  @override
  Future<void> saveBriefing(SavedBriefing briefing) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<SavedBriefing> briefings = await getSavedBriefings();

    // Avoid duplicates by checking conclusion and type
    final bool exists = briefings.any(
      (SavedBriefing b) =>
          b.conclusion == briefing.conclusion && b.type == briefing.type,
    );

    if (!exists) {
      briefings.insert(0, briefing);
      final List<String> encoded = briefings
          .map((SavedBriefing b) => jsonEncode(b.toJson()))
          .toList();
      await prefs.setStringList(_savedBriefingsKey, encoded);
    }
  }

  @override
  Future<List<SavedBriefing>> getSavedBriefings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_savedBriefingsKey);

    if (encoded == null) {
      return <SavedBriefing>[];
    }

    return encoded.map((String s) {
      final Object? json = jsonDecode(s);
      if (json is Map<String, dynamic>) {
        return SavedBriefing.fromJson(json);
      } else {
        // Fallback for unexpected format
        throw const FormatException('Invalid briefing JSON format');
      }
    }).toList();
  }

  @override
  Future<void> deleteBriefing(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<SavedBriefing> briefings = await getSavedBriefings();

    briefings.removeWhere((SavedBriefing b) => b.id == id);

    final List<String> encoded = briefings
        .map((SavedBriefing b) => jsonEncode(b.toJson()))
        .toList();
    await prefs.setStringList(_savedBriefingsKey, encoded);
  }

  @override
  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedBriefingsKey);
  }
}
