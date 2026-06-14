// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) => NewsArticle(
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  articleText: json['articleText'] as String,
  urlSource: json['urlSource'] as String,
  publishedAt: DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$NewsArticleToJson(NewsArticle instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'articleText': instance.articleText,
      'imageUrl': instance.imageUrl,
      'urlSource': instance.urlSource,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
