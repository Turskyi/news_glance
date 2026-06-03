import 'package:json_annotation/json_annotation.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';

part 'saved_briefing.g.dart';

@JsonSerializable()
class SavedBriefing {
  const SavedBriefing({
    required this.id,
    required this.conclusion,
    required this.level,
    required this.probability,
    required this.category,
    required this.type,
    required this.savedAt,
    this.searchQuery,
  });

  factory SavedBriefing.fromActionableInsight({
    required ActionableInsight insight,
    required ConclusionUiStyle type,
    String? searchQuery,
  }) {
    return SavedBriefing(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      conclusion: insight.conclusion,
      level: insight.level,
      probability: insight.probability,
      category: insight.category,
      type: type,
      savedAt: DateTime.now(),
      searchQuery: searchQuery,
    );
  }

  factory SavedBriefing.fromJson(Map<String, Object?> json) =>
      _$SavedBriefingFromJson(json);

  final String id;
  final String conclusion;
  final ActionableInsightLevel level;
  final double probability;
  final InsightCategory category;
  final ConclusionUiStyle type;
  final DateTime savedAt;
  final String? searchQuery;

  Map<String, Object?> toJson() => _$SavedBriefingToJson(this);

  @override
  String toString() {
    return 'SavedBriefing(id: $id, conclusion: $conclusion, level: $level, '
        'probability: $probability, category: $category, type: $type, '
        'savedAt: $savedAt, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SavedBriefing) return false;
    return other.id == id &&
        other.conclusion == conclusion &&
        other.level == level &&
        other.probability == probability &&
        other.category == category &&
        other.type == type &&
        other.savedAt == savedAt &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      conclusion.hashCode ^
      level.hashCode ^
      probability.hashCode ^
      category.hashCode ^
      type.hashCode ^
      savedAt.hashCode ^
      searchQuery.hashCode;
}
