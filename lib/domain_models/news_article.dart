class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.articleText = loremIpsum,
  });

  final String title;
  final String description;
  final String articleText;
  final String imageUrl;
}

const String loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
    'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing '
    'elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
    'ut aliquip ex ea commodo consequat.';
