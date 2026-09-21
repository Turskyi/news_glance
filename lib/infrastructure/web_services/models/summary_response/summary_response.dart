import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary_response.g.dart';

@JsonSerializable()
class SummaryResponse {
  const SummaryResponse({required this.summary, this.model});

  factory SummaryResponse.fromJson(Map<String, Object?> json) {
    return _$SummaryResponseFromJson(json);
  }

  final String summary;
  final String? model;

  @override
  String toString() => 'SummaryResponse(summary: $summary, model: $model)';

  Map<String, Object?> toJson() => _$SummaryResponseToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SummaryResponse) return false;
    final bool Function(Object? _, Object? _) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => summary.hashCode ^ model.hashCode;
}
