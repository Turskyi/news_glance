import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conclusion_response.g.dart';

@JsonSerializable()
class ConclusionResponse {
  const ConclusionResponse({required this.conclusion});

  factory ConclusionResponse.fromJson(Map<String, dynamic> json) {
    return _$ConclusionResponseFromJson(json);
  }

  final String conclusion;

  @override
  String toString() => 'ConclusionResponse(conclusion: $conclusion)';

  Map<String, dynamic> toJson() => _$ConclusionResponseToJson(this);

  ConclusionResponse copyWith({
    String? conclusion,
  }) {
    return ConclusionResponse(
      conclusion: conclusion ?? this.conclusion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ConclusionResponse) return false;
    final bool Function(Object? _, Object? __) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => conclusion.hashCode;
}
