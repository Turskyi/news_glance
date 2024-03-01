import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

@JsonSerializable()
class Source {
  const Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return _$SourceFromJson(json);
  }

  final String? id;
  final String? name;

  @override
  String toString() => 'Source(id: $id, name: $name)';

  Map<String, dynamic> toJson() => _$SourceToJson(this);

  Source copyWith({
    String? id,
    String? name,
  }) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Source) return false;
    final bool Function(Object? _, Object? __) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
