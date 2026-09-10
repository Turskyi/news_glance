const String newsLastFetchAt = 'news_last_fetch_at';
const String conclusionUiStyle = 'conclusion_ui_style';
const String locale = 'locale';
const String themeMode = 'theme_mode';
const String onboardingCompleted = 'onboarding_completed';
const String widgetUpdateFrequency = 'news_glance_widget_update_frequency';
const String widgetStyle = 'widget_style';

/// Home Widget Keys
const String headlineTitle = 'headline_title';
const String headlineDescription = 'headline_description';
const String signalLevel = 'signal_level';
const String signalConclusion = 'signal_conclusion';
const String signalProbability = 'signal_probability';
const String signalCategory = 'signal_category';

String aiCacheConclusion(int checksum) {
  return 'ai_cache_${checksum}_conclusion';
}

String aiCacheInsightConclusion(int checksum) {
  return 'ai_cache_${checksum}_insight_conclusion';
}

String aiCacheInsightLevel(int checksum) {
  return 'ai_cache_${checksum}_insight_level';
}

String aiCacheInsightProbability(int checksum) {
  return 'ai_cache_${checksum}_insight_probability';
}

String aiCacheInsightCategory(int checksum) {
  return 'ai_cache_${checksum}_insight_category';
}

String aiCacheSummary(int checksum) {
  return 'ai_cache_${checksum}_summary';
}
