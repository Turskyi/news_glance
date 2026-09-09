import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conclusion_response.g.dart';

@JsonSerializable()
class ConclusionResponse {
  const ConclusionResponse({required this.conclusion, this.model});

  factory ConclusionResponse.fromJson(Map<String, Object?> json) {
    return _$ConclusionResponseFromJson(json);
  }

  final String conclusion;
  final String? model;

  @override
  String toString() =>
      'ConclusionResponse(conclusion: $conclusion, model: $model)';

  Map<String, Object?> toJson() => _$ConclusionResponseToJson(this);

  ConclusionResponse copyWith({String? conclusion, String? model}) {
    return ConclusionResponse(
      conclusion: conclusion ?? this.conclusion,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ConclusionResponse) return false;
    final bool Function(Object? _, Object? _) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => conclusion.hashCode ^ model.hashCode;
}
