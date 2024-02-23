enum AppRoute {
  home('/'),
  article('/article');

  const AppRoute(this.path);

  final String path;
}
