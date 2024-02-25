// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleResponse _$NewsArticleResponseFromJson(Map<String, dynamic> json) =>
    NewsArticleResponse(
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      urlToImage: json['urlToImage'] as String? ?? '',
      url: json['url'] as String,
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] as String? ?? '',
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$NewsArticleResponseToJson(
        NewsArticleResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'urlToImage': instance.urlToImage,
      'url': instance.url,
      'source': instance.source,
      'author': instance.author,
      'publishedAt': instance.publishedAt,
      'content': instance.content,
    };
