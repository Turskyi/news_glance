import 'dart:ui';

enum AppLocale {
  english('en'),
  ukrainian('uk');

  const AppLocale(this.languageCode);

  final String languageCode;

  Locale get value => Locale(languageCode);

  bool get isUkrainian => this == AppLocale.ukrainian;

  bool get isEnglish => this == AppLocale.english;

  String get displayCode => isUkrainian ? 'UA' : 'EN';

  String get ttsLanguage => isUkrainian ? 'uk-UA' : 'en-US';

  static AppLocale fromLanguageCode(String languageCode) {
    return AppLocale.values.firstWhere(
      (AppLocale locale) => locale.languageCode == languageCode,
      orElse: () => AppLocale.english,
    );
  }
}
