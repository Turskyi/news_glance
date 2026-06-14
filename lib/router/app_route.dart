enum AppRoute {
  home('/'),
  article('/article'),
  articleWeb('/article_web'),
  about('/about'),
  onboarding('/onboarding'),
  search('/search'),
  savedBriefings('/saved_briefings'),
  savedArticles('/saved_articles');

  const AppRoute(this.path);

  final String path;
}
