import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'source.dart';

part 'news_article_response.g.dart';

@JsonSerializable()
class NewsArticleResponse {
  const NewsArticleResponse({
    required this.title,
    this.description = '',
    this.urlToImage = '',
    required this.url,
    required this.source,
    this.author = '',
    required this.publishedAt,
    this.content = '',
  });

  factory NewsArticleResponse.fromJson(Map<String, dynamic> json) {
    return _$NewsArticleResponseFromJson(json);
  }

  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final Source source;
  final String author;
  final String publishedAt;
  final String content;

  @override
  String toString() {
    return 'NewsArticleResponse(source: $source, author: $author, '
        'title: $title, description: $description, url: $url, '
        'urlToImage: $urlToImage, publishedAt: $publishedAt, '
        'content: $content)';
  }

  Map<String, dynamic> toJson() => _$NewsArticleResponseToJson(this);

  NewsArticleResponse copyWith({
    Source? source,
    String? author,
    String? title,
    dynamic description,
    String? url,
    dynamic urlToImage,
    String? publishedAt,
    dynamic content,
  }) =>
      NewsArticleResponse(
        source: source ?? this.source,
        author: author ?? this.author,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        urlToImage: urlToImage ?? this.urlToImage,
        publishedAt: publishedAt ?? this.publishedAt,
        content: content ?? this.content,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! NewsArticleResponse) return false;
    final bool Function(Object? _, Object? __) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      source.hashCode ^
      author.hashCode ^
      title.hashCode ^
      description.hashCode ^
      url.hashCode ^
      urlToImage.hashCode ^
      publishedAt.hashCode ^
      content.hashCode;
}
