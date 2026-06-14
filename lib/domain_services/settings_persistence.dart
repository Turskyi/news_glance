import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';

abstract interface class SettingsPersistence {
  Future<void> saveConclusionUiStyle(ConclusionUiStyle style);

  Future<ConclusionUiStyle?> getConclusionUiStyle();

  Future<void> saveLocale(AppLocale locale);

  Future<AppLocale?> getLocale();

  Future<void> saveThemeMode(ThemeMode themeMode);

  Future<ThemeMode?> getThemeMode();

  Future<void> saveOnboardingCompleted(bool completed);

  Future<bool> isOnboardingCompleted();
}
