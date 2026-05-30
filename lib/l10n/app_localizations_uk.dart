// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Огляд Новин';

  @override
  String get menu => 'Меню';

  @override
  String get search => 'Пошук';

  @override
  String get contactUs => 'Зв\'яжіться з нами';

  @override
  String get actionableInsight => 'Практичне розуміння';

  @override
  String get probability => 'Ймовірність';

  @override
  String get category => 'Категорія';

  @override
  String get signalLevel => 'Рівень сигналу';

  @override
  String get noNewsFound => 'Новин не знайдено';

  @override
  String get language => 'Мова';

  @override
  String get english => 'Англійська';

  @override
  String get ukrainian => 'Українська';

  @override
  String get allClear => 'ВСЕ ЧИСТО';

  @override
  String get criticalAction => 'КРИТИЧНА ДІЯ';

  @override
  String get warning => 'ПОПЕРЕДЖЕННЯ';

  @override
  String get advisory => 'ПОРАДА';

  @override
  String get noImmediateActionRequired => 'Негайних дій не потрібно';

  @override
  String get noNewsAvailable => 'На даний момент новин немає.';

  @override
  String get pleaseCheckBackLater => 'Будь ласка, перевірте пізніше.';

  @override
  String get widgetUpdateFrequency => 'Частота оновлення віджета';

  @override
  String get chooseFrequency =>
      'Виберіть, як часто віджет News Glance оновлюється в Центрі сповіщень';

  @override
  String get conclusionStyle => 'Стиль висновку';

  @override
  String get insight => 'Розуміння';

  @override
  String get conclusion => 'Висновок';

  @override
  String get summary => 'Підсумок';

  @override
  String get conversationalSummary => 'Дружній огляд';

  @override
  String get usingInsight => 'Використовується розуміння';

  @override
  String get usingConclusion => 'Використовується висновок';

  @override
  String get usingSummary => 'Використовується підсумок';

  @override
  String get every4Hours => 'Кожні 4 години';

  @override
  String get every12Hours => 'Кожні 12 годин';

  @override
  String get onceDaily => 'Раз на день (за замовчуванням)';

  @override
  String frequencySetTo(String label) {
    return 'Частота оновлення віджета встановлена на: $label';
  }

  @override
  String get frequencyChanged => 'Частоту оновлення віджета змінено';

  @override
  String get readMore => 'Читати далі';

  @override
  String get readAloud => 'Читати вголос';

  @override
  String get close => 'Закрити';

  @override
  String get source => 'Джерело';

  @override
  String get shareBriefing => 'Поділитися брифінгом';

  @override
  String get briefingShared => 'Брифінг надіслано';

  @override
  String get briefingCopiedToClipboard => 'Брифінг скопійовано';
}
