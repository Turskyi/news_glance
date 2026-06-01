import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'article_request.dart';

part 'conclusion_request.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class ConclusionRequest {
  const ConclusionRequest({required this.articles, this.lang, this.query});

  final List<ArticleRequest> articles;
  final String? lang;
  final String? query;

  @override
  String toString() =>
      'ConclusionRequest(articles: $articles, lang: $lang, query: $query)';

  Map<String, dynamic> toJson() => _$ConclusionRequestToJson(this);

  ConclusionRequest copyWith({
    List<ArticleRequest>? articles,
    String? lang,
    String? query,
  }) {
    return ConclusionRequest(
      articles: articles ?? this.articles,
      lang: lang ?? this.lang,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ConclusionRequest) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  @JsonKey(includeToJson: false)
  int get hashCode => Object.hash(articles, lang, query);
}
