import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: BriefingPersistence)
class SharedPreferencesBriefingPersistence implements BriefingPersistence {
  @override
  Future<void> saveConclusion({
    required int checksum,
    required String text,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storage_keys.aiCacheConclusion(checksum), text);
  }

  @override
  Future<String?> getConclusion(int checksum) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(storage_keys.aiCacheConclusion(checksum));
  }

  @override
  Future<void> saveSummary({
    required int checksum,
    required String text,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storage_keys.aiCacheSummary(checksum), text);
  }

  @override
  Future<String?> getSummary(int checksum) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(storage_keys.aiCacheSummary(checksum));
  }

  @override
  Future<void> saveInsight({
    required int checksum,
    required ActionableInsight insight,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storage_keys.aiCacheInsightConclusion(checksum),
      insight.conclusion,
    );
    await prefs.setString(
      storage_keys.aiCacheInsightLevel(checksum),
      insight.level.value,
    );
    await prefs.setDouble(
      storage_keys.aiCacheInsightProbability(checksum),
      insight.probability,
    );
    await prefs.setString(
      storage_keys.aiCacheInsightCategory(checksum),
      insight.category.value,
    );
  }

  @override
  Future<ActionableInsight?> getInsight(int checksum) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? conclusion = prefs.getString(
      storage_keys.aiCacheInsightConclusion(checksum),
    );

    if (conclusion == null || conclusion.isEmpty) {
      return null;
    }

    final String? levelStr = prefs.getString(
      storage_keys.aiCacheInsightLevel(checksum),
    );
    final double? prob = prefs.getDouble(
      storage_keys.aiCacheInsightProbability(checksum),
    );
    final String? categoryStr = prefs.getString(
      storage_keys.aiCacheInsightCategory(checksum),
    );

    return ActionableInsight(
      conclusion: conclusion,
      level: ActionableInsightLevel.fromString(levelStr ?? 'NEUTRAL'),
      probability: prob ?? 0.0,
      category: InsightCategory.fromString(categoryStr ?? 'GENERAL'),
    );
  }

  @override
  Future<void> saveLastFetchTime(DateTime time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      storage_keys.newsLastFetchAt,
      time.millisecondsSinceEpoch,
    );
  }

  @override
  Future<DateTime?> getLastFetchTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(storage_keys.newsLastFetchAt);
    if (raw == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(raw);
  }
}
