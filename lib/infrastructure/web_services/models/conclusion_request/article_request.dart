import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_request.g.dart';

@JsonSerializable(createFactory: false)
class ArticleRequest {
  const ArticleRequest({
    required this.title,
    this.description,
    this.articleText,
  });

  final String title;
  final String? description;
  final String? articleText;

  @override
  String toString() {
    return 'Article(title: $title, description: $description, '
        'articleText: $articleText)';
  }

  Map<String, dynamic> toJson() => _$ArticleRequestToJson(this);

  ArticleRequest copyWith({
    String? title,
    String? description,
    String? articleText,
  }) {
    return ArticleRequest(
      title: title ?? this.title,
      description: description ?? this.description,
      articleText: articleText ?? this.articleText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ArticleRequest) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      title.hashCode ^ description.hashCode ^ articleText.hashCode;
}
