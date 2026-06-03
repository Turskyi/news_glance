import 'package:json_annotation/json_annotation.dart';

part 'news_article.g.dart';

@JsonSerializable()
class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleText,
    required this.urlSource,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, Object?> json) =>
      _$NewsArticleFromJson(json);

  final String title;
  final String description;
  final String articleText;
  final String imageUrl;
  final String urlSource;
  final DateTime publishedAt;

  Map<String, Object?> toJson() => _$NewsArticleToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! NewsArticle) {
      return false;
    }
    return other.urlSource == urlSource;
  }

  @override
  int get hashCode => urlSource.hashCode;
}
