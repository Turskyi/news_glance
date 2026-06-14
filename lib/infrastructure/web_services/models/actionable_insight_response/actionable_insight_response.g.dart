// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actionable_insight_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionableInsightResponse _$ActionableInsightResponseFromJson(
  Map<String, dynamic> json,
) => ActionableInsightResponse(
  conclusion: json['conclusion'] as String,
  level: _levelFromJson(json['level'] as String),
  probability: (json['probability'] as num).toDouble(),
  category: _categoryFromJson(json['category'] as String),
);

Map<String, dynamic> _$ActionableInsightResponseToJson(
  ActionableInsightResponse instance,
) => <String, dynamic>{
  'conclusion': instance.conclusion,
  'level': _levelToJson(instance.level),
  'probability': instance.probability,
  'category': _categoryToJson(instance.category),
};
