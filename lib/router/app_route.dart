enum AppRoute {
  home('/'),
  article('/article'),
  articleWeb('/article_web');

  const AppRoute(this.path);

  final String path;
}
