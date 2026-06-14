// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_briefing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedBriefing _$SavedBriefingFromJson(Map<String, dynamic> json) =>
    SavedBriefing(
      id: json['id'] as String,
      conclusion: json['conclusion'] as String,
      level: $enumDecode(_$ActionableInsightLevelEnumMap, json['level']),
      probability: (json['probability'] as num).toDouble(),
      category: $enumDecode(_$InsightCategoryEnumMap, json['category']),
      type: $enumDecode(_$ConclusionUiStyleEnumMap, json['type']),
      savedAt: DateTime.parse(json['savedAt'] as String),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$SavedBriefingToJson(SavedBriefing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conclusion': instance.conclusion,
      'level': _$ActionableInsightLevelEnumMap[instance.level]!,
      'probability': instance.probability,
      'category': _$InsightCategoryEnumMap[instance.category]!,
      'type': _$ConclusionUiStyleEnumMap[instance.type]!,
      'savedAt': instance.savedAt.toIso8601String(),
      'searchQuery': instance.searchQuery,
    };

const _$ActionableInsightLevelEnumMap = {
  ActionableInsightLevel.critical: 'critical',
  ActionableInsightLevel.warning: 'warning',
  ActionableInsightLevel.advisory: 'advisory',
  ActionableInsightLevel.neutral: 'neutral',
};

const _$InsightCategoryEnumMap = {
  InsightCategory.travel: 'travel',
  InsightCategory.finance: 'finance',
  InsightCategory.safety: 'safety',
  InsightCategory.health: 'health',
  InsightCategory.lifestyle: 'lifestyle',
  InsightCategory.general: 'general',
};

const _$ConclusionUiStyleEnumMap = {
  ConclusionUiStyle.insight: 'insight',
  ConclusionUiStyle.conclusion: 'conclusion',
  ConclusionUiStyle.summary: 'summary',
};
