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
  String get usingInsight => 'Using Insight';

  @override
  String get usingConclusion => 'Using Conclusion';

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
  String get close => 'Close';

  @override
  String get source => 'Source';
}
