import 'package:news_glance/domain_models/actionable_insight.dart';

abstract interface class BriefingPersistence {
  Future<void> saveConclusion({required int checksum, required String text});

  Future<String?> getConclusion(int checksum);

  Future<void> saveSummary({required int checksum, required String text});

  Future<String?> getSummary(int checksum);

  Future<void> saveInsight({
    required int checksum,
    required ActionableInsight insight,
  });

  Future<ActionableInsight?> getInsight(int checksum);

  Future<void> saveLastFetchTime(DateTime time);

  Future<DateTime?> getLastFetchTime();
}
