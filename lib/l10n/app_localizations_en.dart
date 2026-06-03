// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'News Glance';

  @override
  String get menu => 'Menu';

  @override
  String get search => 'Search';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get actionableInsight => 'Actionable Insight';

  @override
  String get probability => 'Probability';

  @override
  String get category => 'Category';

  @override
  String get signalLevel => 'Signal Level';

  @override
  String get noNewsFound => 'No news found';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get allClear => 'ALL CLEAR';

  @override
  String get criticalAction => 'CRITICAL ACTION';

  @override
  String get warning => 'WARNING';

  @override
  String get advisory => 'ADVISORY';

  @override
  String get noImmediateActionRequired => 'No immediate action required';

  @override
  String get noNewsAvailable => 'No news available at the moment.';

  @override
  String get pleaseCheckBackLater => 'Please check back later.';

  @override
  String get widgetUpdateFrequency => 'Widget Update Frequency';

  @override
  String get chooseFrequency =>
      'Choose how often the News Glance widget updates in Notification Center';

  @override
  String get conclusionStyle => 'Conclusion Style';

  @override
  String get insight => 'Insight';

  @override
  String get conclusion => 'Conclusion';

  @override
  String get summary => 'Summary';

  @override
  String get conversationalSummary => 'Conversational Summary';

  @override
  String get usingInsight => 'Using Insight';

  @override
  String get usingConclusion => 'Using Conclusion';

  @override
  String get usingSummary => 'Using Summary';

  @override
  String get every4Hours => 'Every 4 hours';

  @override
  String get every12Hours => 'Every 12 hours';

  @override
  String get onceDaily => 'Once daily (default)';

  @override
  String frequencySetTo(String label) {
    return 'Widget update frequency set to: $label';
  }

  @override
  String get frequencyChanged => 'Widget update frequency changed';

  @override
  String get readMore => 'Read More';

  @override
  String get readAloud => 'Read Aloud';

  @override
  String get close => '🗑 Clear History';

  @override
  String get source => 'Source';

  @override
  String get shareBriefing => 'Share briefing';

  @override
  String get searchNews => 'News Glance Search';

  @override
  String get searchQueryLabel => 'Enter your search query';

  @override
  String get searchPlaceholder => 'e.g. Technology, AI, Space...';

  @override
  String get searchButtonText => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get noResultsFound => 'No results found.';

  @override
  String get searchError => 'An error occurred while searching.';

  @override
  String get briefingShared => 'Briefing shared';

  @override
  String get briefingCopiedToClipboard => 'Briefing copied to clipboard';

  @override
  String get saveBriefing => 'Save briefing';

  @override
  String get briefingSaved => 'Briefing saved';

  @override
  String get savedInsights => 'Saved Insights';

  @override
  String get noSavedInsights => 'No saved insights yet.';

  @override
  String get savedArticles => 'Saved Articles';

  @override
  String get noSavedArticles => 'No saved articles yet.';

  @override
  String get saveArticlesToReadLater => 'Save articles to read later.';

  @override
  String get articleSaved => 'Article saved';

  @override
  String get articleRemoved => 'Article removed from bookmarks';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure you want to delete this briefing?';

  @override
  String get cancel => 'Cancel';

  @override
  String aboutApp(String appName) {
    return 'About $appName';
  }

  @override
  String get tagline => 'AI-powered daily situational awareness.';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get whatIsNewsGlance => 'What Is News Glance?';

  @override
  String get whatIsNewsGlanceContent =>
      'News Glance helps you understand what today\'s major world events may mean in practice.\n\nRather than simply showing headlines, News Glance uses AI to identify important patterns across multiple international stories and generate a concise daily briefing.';

  @override
  String get whyItExists => 'Why It Exists';

  @override
  String get whyItExistsContent =>
      'The idea behind News Glance was inspired by real-world situations where important warning signals appeared across many separate news stories, but were difficult to interpret collectively.\n\nNews Glance attempts to connect those signals and answer a simple question:\n\n\'Is there anything I should pay attention to today beyond simply staying informed?\'';

  @override
  String get howItWorks => 'How It Works';

  @override
  String get step1 => '1. Collect important international news.';

  @override
  String get step2 => '2. Analyze stories collectively using AI.';

  @override
  String get step3 => '3. Generate a short plain-language briefing.';

  @override
  String get exampleBriefing => 'Example Briefing';

  @override
  String get dailyHeadsUp => 'Daily Heads-Up';

  @override
  String get exampleBriefingContent =>
      '✈️ Rising regional instability may affect travel plans. If you have non-essential travel scheduled to affected areas, consider monitoring official advisories.';

  @override
  String get illustrativeExample =>
      'This is an illustrative example, not advice.';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get featureAiBriefing => 'AI-generated daily briefing';

  @override
  String get featureGlobalMonitoring => 'Global news monitoring';

  @override
  String get featureReadingExperience => 'Article reading experience';

  @override
  String get featureHomeWidget => 'Home screen widget';

  @override
  String get featureShareableInsights => 'Shareable insights';

  @override
  String get featureOriginalSources => 'Optional access to original sources';

  @override
  String get transparency => 'Transparency';

  @override
  String get transparencyContent =>
      'News Glance is designed to help users stay informed and aware of emerging situations.\n\nAI-generated briefings may be incomplete or incorrect and should not be considered professional, financial, legal, medical, or safety advice.';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyContent =>
      'News Glance does not require user accounts and does not collect personal information for app functionality.\n\nExternal websites and services may be governed by their own privacy policies.';

  @override
  String copyright(int year, String appName) {
    return '© $year $appName';
  }
}
