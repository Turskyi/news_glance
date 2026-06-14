import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'News Glance'**
  String get appName;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @actionableInsight.
  ///
  /// In en, this message translates to:
  /// **'Actionable Insight'**
  String get actionableInsight;

  /// No description provided for @probability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get probability;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @travelCategory.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travelCategory;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeCategory;

  /// No description provided for @safetyCategory.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetyCategory;

  /// No description provided for @healthCategory.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthCategory;

  /// No description provided for @lifestyleCategory.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyleCategory;

  /// No description provided for @generalCategory.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalCategory;

  /// No description provided for @signalLevel.
  ///
  /// In en, this message translates to:
  /// **'Signal Level'**
  String get signalLevel;

  /// No description provided for @noNewsFound.
  ///
  /// In en, this message translates to:
  /// **'No news found'**
  String get noNewsFound;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'ALL CLEAR'**
  String get allClear;

  /// No description provided for @criticalAction.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL ACTION'**
  String get criticalAction;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get warning;

  /// No description provided for @advisory.
  ///
  /// In en, this message translates to:
  /// **'ADVISORY'**
  String get advisory;

  /// No description provided for @noImmediateActionRequired.
  ///
  /// In en, this message translates to:
  /// **'No immediate action required'**
  String get noImmediateActionRequired;

  /// No description provided for @noNewsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No news available at the moment.'**
  String get noNewsAvailable;

  /// No description provided for @pleaseCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'Please check back later.'**
  String get pleaseCheckBackLater;

  /// No description provided for @widgetUpdateFrequency.
  ///
  /// In en, this message translates to:
  /// **'Widget Update Frequency'**
  String get widgetUpdateFrequency;

  /// No description provided for @chooseFrequency.
  ///
  /// In en, this message translates to:
  /// **'Choose how often the News Glance widget updates in Notification Center'**
  String get chooseFrequency;

  /// No description provided for @conclusionStyle.
  ///
  /// In en, this message translates to:
  /// **'Conclusion Style'**
  String get conclusionStyle;

  /// No description provided for @insight.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get insight;

  /// No description provided for @conclusion.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get conclusion;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @conversationalSummary.
  ///
  /// In en, this message translates to:
  /// **'Conversational Summary'**
  String get conversationalSummary;

  /// No description provided for @usingInsight.
  ///
  /// In en, this message translates to:
  /// **'Using Insight'**
  String get usingInsight;

  /// No description provided for @usingConclusion.
  ///
  /// In en, this message translates to:
  /// **'Using Conclusion'**
  String get usingConclusion;

  /// No description provided for @usingSummary.
  ///
  /// In en, this message translates to:
  /// **'Using Summary'**
  String get usingSummary;

  /// No description provided for @every4Hours.
  ///
  /// In en, this message translates to:
  /// **'Every 4 hours'**
  String get every4Hours;

  /// No description provided for @every12Hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get every12Hours;

  /// No description provided for @onceDaily.
  ///
  /// In en, this message translates to:
  /// **'Once daily (default)'**
  String get onceDaily;

  /// No description provided for @frequencySetTo.
  ///
  /// In en, this message translates to:
  /// **'Widget update frequency set to: {label}'**
  String frequencySetTo(String label);

  /// No description provided for @frequencyChanged.
  ///
  /// In en, this message translates to:
  /// **'Widget update frequency changed'**
  String get frequencyChanged;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @readAloud.
  ///
  /// In en, this message translates to:
  /// **'Read Aloud'**
  String get readAloud;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'🗑 Clear History'**
  String get close;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @shareBriefing.
  ///
  /// In en, this message translates to:
  /// **'Share briefing'**
  String get shareBriefing;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @linkCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopiedToClipboard;

  /// No description provided for @searchNews.
  ///
  /// In en, this message translates to:
  /// **'News Glance Search'**
  String get searchNews;

  /// No description provided for @searchQueryLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your search query'**
  String get searchQueryLabel;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Technology, AI, Space...'**
  String get searchPlaceholder;

  /// No description provided for @searchButtonText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButtonText;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while searching.'**
  String get searchError;

  /// No description provided for @briefingShared.
  ///
  /// In en, this message translates to:
  /// **'Briefing shared'**
  String get briefingShared;

  /// No description provided for @briefingCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Briefing copied to clipboard'**
  String get briefingCopiedToClipboard;

  /// No description provided for @saveBriefing.
  ///
  /// In en, this message translates to:
  /// **'Save briefing'**
  String get saveBriefing;

  /// No description provided for @briefingSaved.
  ///
  /// In en, this message translates to:
  /// **'Briefing saved'**
  String get briefingSaved;

  /// No description provided for @savedInsights.
  ///
  /// In en, this message translates to:
  /// **'Saved Insights'**
  String get savedInsights;

  /// No description provided for @noSavedInsights.
  ///
  /// In en, this message translates to:
  /// **'No saved insights yet.'**
  String get noSavedInsights;

  /// No description provided for @savedArticles.
  ///
  /// In en, this message translates to:
  /// **'Saved Articles'**
  String get savedArticles;

  /// No description provided for @noSavedArticles.
  ///
  /// In en, this message translates to:
  /// **'No saved articles yet.'**
  String get noSavedArticles;

  /// No description provided for @saveArticlesToReadLater.
  ///
  /// In en, this message translates to:
  /// **'Save articles to read later.'**
  String get saveArticlesToReadLater;

  /// No description provided for @articleSaved.
  ///
  /// In en, this message translates to:
  /// **'Article saved'**
  String get articleSaved;

  /// No description provided for @articleRemoved.
  ///
  /// In en, this message translates to:
  /// **'Article removed from bookmarks'**
  String get articleRemoved;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this briefing?'**
  String get confirmDelete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About {appName}'**
  String aboutApp(String appName);

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'AI-powered daily situational awareness.'**
  String get tagline;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @whatIsNewsGlance.
  ///
  /// In en, this message translates to:
  /// **'What Is News Glance?'**
  String get whatIsNewsGlance;

  /// No description provided for @whatIsNewsGlanceContent.
  ///
  /// In en, this message translates to:
  /// **'News Glance helps you understand what today\'s major world events may mean in practice.\n\nRather than simply showing headlines, News Glance uses AI to identify important patterns across multiple international stories and generate a concise daily briefing.'**
  String get whatIsNewsGlanceContent;

  /// No description provided for @whyItExists.
  ///
  /// In en, this message translates to:
  /// **'Why It Exists'**
  String get whyItExists;

  /// No description provided for @whyItExistsContent.
  ///
  /// In en, this message translates to:
  /// **'The idea behind News Glance was inspired by real-world situations where important warning signals appeared across many separate news stories, but were difficult to interpret collectively.\n\nNews Glance attempts to connect those signals and answer a simple question:\n\n\'Is there anything I should pay attention to today beyond simply staying informed?\''**
  String get whyItExistsContent;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get howItWorks;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'1. Collect important international news.'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'2. Analyze stories collectively using AI.'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'3. Generate a short plain-language briefing.'**
  String get step3;

  /// No description provided for @exampleBriefing.
  ///
  /// In en, this message translates to:
  /// **'Example Briefing'**
  String get exampleBriefing;

  /// No description provided for @dailyHeadsUp.
  ///
  /// In en, this message translates to:
  /// **'Daily Heads-Up'**
  String get dailyHeadsUp;

  /// No description provided for @exampleBriefingContent.
  ///
  /// In en, this message translates to:
  /// **'✈️ Rising regional instability may affect travel plans. If you have non-essential travel scheduled to affected areas, consider monitoring official advisories.'**
  String get exampleBriefingContent;

  /// No description provided for @illustrativeExample.
  ///
  /// In en, this message translates to:
  /// **'This is an illustrative example, not advice.'**
  String get illustrativeExample;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @featureAiBriefing.
  ///
  /// In en, this message translates to:
  /// **'AI-generated daily briefing'**
  String get featureAiBriefing;

  /// No description provided for @featureGlobalMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Global news monitoring'**
  String get featureGlobalMonitoring;

  /// No description provided for @featureReadingExperience.
  ///
  /// In en, this message translates to:
  /// **'Article reading experience'**
  String get featureReadingExperience;

  /// No description provided for @featureHomeWidget.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get featureHomeWidget;

  /// No description provided for @featureShareableInsights.
  ///
  /// In en, this message translates to:
  /// **'Shareable insights'**
  String get featureShareableInsights;

  /// No description provided for @featureOriginalSources.
  ///
  /// In en, this message translates to:
  /// **'Optional access to original sources'**
  String get featureOriginalSources;

  /// No description provided for @transparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get transparency;

  /// No description provided for @transparencyContent.
  ///
  /// In en, this message translates to:
  /// **'News Glance is designed to help users stay informed and aware of emerging situations.\n\nAI-generated briefings may be incomplete or incorrect and should not be considered professional, financial, legal, medical, or safety advice.'**
  String get transparencyContent;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyContent.
  ///
  /// In en, this message translates to:
  /// **'News Glance does not require user accounts and does not collect personal information for app functionality.\n\nExternal websites and services may be governed by their own privacy policies.'**
  String get privacyContent;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} {appName}'**
  String copyright(int year, String appName);

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Briefings'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'News Glance analyzes multiple international news stories and generates an AI-powered briefing designed to help you quickly understand what matters today.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'See the Bigger Picture'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Individual headlines can be noisy and disconnected. News Glance looks across multiple stories and attempts to identify broader patterns, emerging situations, and practical takeaways.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Briefing Style'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'News Glance offers three ways to understand the news:\n\n• Insight - concise signal-oriented briefing\n\n• Conclusion - practical takeaway based on current events\n\n• Summary - a longer, conversational overview of today\'s developments\n\nYou can switch between styles at any time from the menu.'**
  String get onboardingBody3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @pinWidget.
  ///
  /// In en, this message translates to:
  /// **'Pin Widget'**
  String get pinWidget;

  /// No description provided for @pinWidgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Add the News Glance widget to your home screen for quick access.'**
  String get pinWidgetDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
