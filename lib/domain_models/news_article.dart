class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleText,
    required this.urlSource,
  });

  final String title;
  final String description;
  final String articleText;
  final String imageUrl;
  final String urlSource;
}
