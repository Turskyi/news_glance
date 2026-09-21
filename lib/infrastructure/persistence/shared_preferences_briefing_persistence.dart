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
    required ActionableInsight insight,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storage_keys.aiCacheConclusion(checksum),
      insight.conclusion,
    );
    final String? model = insight.model;
    if (model != null) {
      await prefs.setString(
        storage_keys.aiCacheConclusionModel(checksum),
        model,
      );
    }
  }

  @override
  Future<ActionableInsight?> getConclusion(int checksum) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? conclusion = prefs.getString(
      storage_keys.aiCacheConclusion(checksum),
    );
    if (conclusion == null || conclusion.isEmpty) {
      return null;
    }
    final String? model = prefs.getString(
      storage_keys.aiCacheConclusionModel(checksum),
    );
    return ActionableInsight(
      conclusion: conclusion,
      level: ActionableInsightLevel.neutral,
      probability: 0.0,
      category: InsightCategory.general,
      model: model,
    );
  }

  @override
  Future<void> saveSummary({
    required int checksum,
    required ActionableInsight insight,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storage_keys.aiCacheSummary(checksum),
      insight.conclusion,
    );
    final String? model = insight.model;
    if (model != null) {
      await prefs.setString(storage_keys.aiCacheSummaryModel(checksum), model);
    }
  }

  @override
  Future<ActionableInsight?> getSummary(int checksum) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? summary = prefs.getString(
      storage_keys.aiCacheSummary(checksum),
    );
    if (summary == null || summary.isEmpty) {
      return null;
    }
    final String? model = prefs.getString(
      storage_keys.aiCacheSummaryModel(checksum),
    );
    return ActionableInsight(
      conclusion: summary,
      level: ActionableInsightLevel.neutral,
      probability: 0.0,
      category: InsightCategory.general,
      model: model,
    );
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
    final String? model = insight.model;
    if (model != null) {
      await prefs.setString(storage_keys.aiCacheInsightModel(checksum), model);
    }
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
    final String? model = prefs.getString(
      storage_keys.aiCacheInsightModel(checksum),
    );

    return ActionableInsight(
      conclusion: conclusion,
      level: ActionableInsightLevel.fromString(levelStr ?? 'NEUTRAL'),
      probability: prob ?? 0.0,
      category: InsightCategory.fromString(categoryStr ?? 'GENERAL'),
      model: model,
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
