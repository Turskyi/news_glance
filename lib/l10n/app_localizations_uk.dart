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

  @override
  String aboutApp(String appName) {
    return 'Про $appName';
  }

  @override
  String get tagline => 'Ситуаційна обізнаність на базі ШІ.';

  @override
  String version(String version) {
    return 'Версія $version';
  }

  @override
  String get whatIsNewsGlance => 'Що таке News Glance?';

  @override
  String get whatIsNewsGlanceContent =>
      'News Glance допомагає зрозуміти, що можуть означати головні світові події на практиці.\n\nЗамість того, щоб просто показувати заголовки, News Glance використовує ШІ для виявлення важливих закономірностей у багатьох міжнародних історіях і створює стислий щоденний брифінг.';

  @override
  String get whyItExists => 'Чому він існує';

  @override
  String get whyItExistsContent =>
      'Ідея News Glance була натхненна реальними ситуаціями, коли важливі сигнали застереження з\'являлися в багатьох окремих новинах, але їх було важко інтерпретувати разом.\n\nNews Glance намагається поєднати ці сигнали та відповісти на просте запитання:\n\n\'Чи є щось, на що мені варто звернути увагу сьогодні, крім того, щоб просто бути поінформованим?\'';

  @override
  String get howItWorks => 'Як це працює';

  @override
  String get step1 => '1. Збір важливих міжнародних новин.';

  @override
  String get step2 => '2. Колективний аналіз історій за допомогою ШІ.';

  @override
  String get step3 => '3. Створення короткого брифінгу простою мовою.';

  @override
  String get exampleBriefing => 'Приклад брифінгу';

  @override
  String get dailyHeadsUp => 'Щоденне застереження';

  @override
  String get exampleBriefingContent =>
      '✈️ Зростання регіональної нестабільності може вплинути на плани подорожей. Якщо у вас заплановані необов\'язкові поїздки до уражених регіонів, розгляньте можливість моніторингу офіційних рекомендацій.';

  @override
  String get illustrativeExample => 'Це ілюстративний приклад, а не порада.';

  @override
  String get keyFeatures => 'Ключові особливості';

  @override
  String get featureAiBriefing => 'Щоденний брифінг від ШІ';

  @override
  String get featureGlobalMonitoring => 'Моніторинг світових новин';

  @override
  String get featureReadingExperience => 'Зручне читання статей';

  @override
  String get featureHomeWidget => 'Віджет для головного екрана';

  @override
  String get featureShareableInsights => 'Можливість ділитися аналітикою';

  @override
  String get featureOriginalSources => 'Доступ до оригінальних джерел';

  @override
  String get transparency => 'Прозорість';

  @override
  String get transparencyContent =>
      'News Glance створений, щоб допомогти користувачам залишатися поінформованими та обізнаними про ситуації, що розвиваються.\n\nБрифінги, створені ШІ, можуть бути неповними або неправильними і не повинні вважатися професійними, фінансовими, юридичними, медичними порадами або порадами щодо безпеки.';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyContent =>
      'News Glance не потребує облікових записів і не збирає особисту інформацію для роботи програми.\n\nЗовнішні вебсайти та служби можуть керуватися власною політикою конфіденційності.';

  @override
  String copyright(int year, String appName) {
    return '© $year $appName';
  }
}
