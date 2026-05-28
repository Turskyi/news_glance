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
  /// **'Close'**
  String get close;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;
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
