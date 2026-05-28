import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'article_request.dart';

part 'conclusion_request.g.dart';

@JsonSerializable(createFactory: false)
class ConclusionRequest {
  const ConclusionRequest({required this.articles, this.lang});

  final List<ArticleRequest> articles;
  final String? lang;

  @override
  String toString() => 'ConclusionRequest(articles: $articles, lang: $lang)';

  Map<String, dynamic> toJson() => _$ConclusionRequestToJson(this);

  ConclusionRequest copyWith({List<ArticleRequest>? articles, String? lang}) {
    return ConclusionRequest(
      articles: articles ?? this.articles,
      lang: lang ?? this.lang,
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
  int get hashCode => Object.hash(articles, lang);
}
