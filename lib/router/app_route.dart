enum AppRoute {
  home('/'),
  article('/article'),
  articleWeb('/article_web'),
  about('/about'),
  search('/search');

  const AppRoute(this.path);

  final String path;
}
