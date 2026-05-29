import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary_response.g.dart';

@JsonSerializable()
class SummaryResponse {
  const SummaryResponse({required this.summary});

  factory SummaryResponse.fromJson(Map<String, Object?> json) {
    return _$SummaryResponseFromJson(json);
  }

  final String summary;

  @override
  String toString() => 'SummaryResponse(summary: $summary)';

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
  int get hashCode => summary.hashCode;
}
