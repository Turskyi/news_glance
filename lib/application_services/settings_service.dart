import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/domain_services/settings_persistence.dart';

@injectable
class SettingsService {
  const SettingsService(this._persistence, this._homeWidgetService);

  final SettingsPersistence _persistence;
  final HomeWidgetService _homeWidgetService;

  Future<void> setConclusionUiStyle(ConclusionUiStyle style) async {
    await _persistence.saveConclusionUiStyle(style);

    // Also save widget_style via home widget service for platform widgets
    late final String widgetStyle;
    switch (style) {
      case ConclusionUiStyle.insight:
        widgetStyle = 'insight';
      case ConclusionUiStyle.conclusion:
        widgetStyle = 'conclusion';
      case ConclusionUiStyle.summary:
        widgetStyle = 'summary';
    }
    await _homeWidgetService.setWidgetStyle(widgetStyle);
  }

  Future<ConclusionUiStyle> getConclusionUiStyle() async {
    final ConclusionUiStyle? style = await _persistence.getConclusionUiStyle();
    return style ?? ConclusionUiStyle.insight;
  }

  Future<void> setLocale(AppLocale locale) async {
    await _persistence.saveLocale(locale);
  }

  Future<AppLocale> getLocale() async {
    final AppLocale? locale = await _persistence.getLocale();
    return locale ?? AppLocale.english;
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _persistence.saveThemeMode(themeMode);
  }

  Future<ThemeMode> getThemeMode() async {
    final ThemeMode? themeMode = await _persistence.getThemeMode();
    return themeMode ?? ThemeMode.system;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _persistence.saveOnboardingCompleted(completed);
  }

  Future<bool> isOnboardingCompleted() async {
    return _persistence.isOnboardingCompleted();
  }
}
