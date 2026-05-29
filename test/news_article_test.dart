import 'package:flutter_test/flutter_test.dart';
import 'package:news_glance/domain_models/news_article.dart';

void main() {
  group('NewsArticle', () {
    test('should be correctly instantiated', () {
      const String title = 'Test Title';
      const String description = 'Test Description';
      const String imageUrl = 'https://example.com/image.png';
      const String articleText = 'Test Article Text';
      const String urlSource = 'https://example.com/article';

      NewsArticle article = NewsArticle(
        title: title,
        description: description,
        imageUrl: imageUrl,
        articleText: articleText,
        urlSource: urlSource,
        publishedAt: DateTime.now(),
      );

      expect(article.title, title);
      expect(article.description, description);
      expect(article.imageUrl, imageUrl);
      expect(article.articleText, articleText);
      expect(article.urlSource, urlSource);
    });
  });
}
