import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';
import 'package:news_glance/infrastructure/web_services/models/conclusion_response/conclusion_response.dart';

class ActionableInsight {
  const ActionableInsight({
    required this.conclusion,
    required this.level,
    required this.probability,
    required this.category,
  });

  factory ActionableInsight.fromPlainText(ConclusionResponse response) {
    return ActionableInsight(
      conclusion: response.conclusion,
      level: ActionableInsightLevel.neutral,
      probability: 0.0,
      category: InsightCategory.general,
    );
  }

  final String conclusion;
  final ActionableInsightLevel level;
  final double probability;
  final InsightCategory category;

  bool get isNeutral => level == ActionableInsightLevel.neutral;

  bool get isCritical => level == ActionableInsightLevel.critical;

  bool get isWarning => level == ActionableInsightLevel.warning;

  bool get isAdvisory => level == ActionableInsightLevel.advisory;

  @override
  String toString() =>
      'ActionableInsight(conclusion: $conclusion, level: $level, '
      'probability: $probability, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ActionableInsight) return false;
    return other.conclusion == conclusion &&
        other.level == level &&
        other.probability == probability &&
        other.category == category;
  }

  @override
  int get hashCode =>
      conclusion.hashCode ^
      level.hashCode ^
      probability.hashCode ^
      category.hashCode;
}
