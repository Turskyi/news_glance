import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/insight_category.dart';

part 'actionable_insight_response.g.dart';

@JsonSerializable()
class ActionableInsightResponse {
  const ActionableInsightResponse({
    required this.conclusion,
    required this.level,
    required this.probability,
    required this.category,
  });

  factory ActionableInsightResponse.fromJson(Map<String, Object?> json) {
    return _$ActionableInsightResponseFromJson(json);
  }

  final String conclusion;

  @JsonKey(fromJson: _levelFromJson, toJson: _levelToJson)
  final ActionableInsightLevel level;

  final double probability;

  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  final InsightCategory category;

  @override
  String toString() =>
      'ActionableInsightResponse(conclusion: $conclusion, level: $level, '
      'probability: $probability, category: $category)';

  Map<String, Object?> toJson() => _$ActionableInsightResponseToJson(this);

  ActionableInsightResponse copyWith({
    String? conclusion,
    ActionableInsightLevel? level,
    double? probability,
    InsightCategory? category,
  }) {
    return ActionableInsightResponse(
      conclusion: conclusion ?? this.conclusion,
      level: level ?? this.level,
      probability: probability ?? this.probability,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ActionableInsightResponse) return false;
    final Function deepEquals = const DeepCollectionEquality().equals;
    return deepEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      conclusion.hashCode ^
      level.hashCode ^
      probability.hashCode ^
      category.hashCode;
}

ActionableInsightLevel _levelFromJson(String value) {
  return ActionableInsightLevel.fromString(value);
}

String _levelToJson(ActionableInsightLevel level) {
  return level.value;
}

InsightCategory _categoryFromJson(String value) {
  return InsightCategory.fromString(value);
}

String _categoryToJson(InsightCategory category) {
  return category.value;
}
