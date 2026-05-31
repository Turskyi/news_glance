enum AppRoute {
  home('/'),
  article('/article'),
  articleWeb('/article_web'),
  about('/about');

  const AppRoute(this.path);

  final String path;
}
