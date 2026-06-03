import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/settings_persistence.dart';
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SettingsPersistence)
class SharedPreferencesSettingsPersistence implements SettingsPersistence {
  @override
  Future<void> saveConclusionUiStyle(ConclusionUiStyle style) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(storage_keys.conclusionUiStyle, style.index);
  }

  @override
  Future<ConclusionUiStyle?> getConclusionUiStyle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(storage_keys.conclusionUiStyle);

    if (raw == null || raw < 0 || raw >= ConclusionUiStyle.values.length) {
      return null;
    }

    return ConclusionUiStyle.values[raw];
  }

  @override
  Future<void> saveLocale(AppLocale locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storage_keys.locale, locale.languageCode);
  }

  @override
  Future<AppLocale?> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(storage_keys.locale);

    if (languageCode == null) {
      return null;
    }

    for (final AppLocale locale in AppLocale.values) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }

    return null;
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storage_keys.themeMode, themeMode.name);
  }

  @override
  Future<ThemeMode?> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storage_keys.themeMode);

    if (raw == null) {
      return null;
    }

    return ThemeMode.values.byName(raw);
  }

  @override
  Future<void> saveOnboardingCompleted(bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(storage_keys.onboardingCompleted, completed);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(storage_keys.onboardingCompleted) ?? false;
  }
}
