AI Guardrails for News Glance

Purpose

- Centralize high-level AI usage rules and implementation points so developers
  and reviewers can find and follow them.

Current enforced rules

- Use Bloc (SettingsBloc/NewsBloc) not Cubit for cross-component state that
  drives UI and side effects.
- Avoid unnecessary re-fetches: when switching UI styles, do not re-download
  news; only regenerate AI outputs when missing or when the news set changed.
- Cache AI outputs per news checksum and persist to SharedPreferences using keys
  managed in `lib/res/storage_keys.dart`.
- Widget integration must read `widget_style` from app group/shared prefs and
  render matching style ("insight" or "conclusion").
- When writing widget payloads, include widget_style and (optionally) the news
  checksum so widget can access cached AI text.
- Avoid creating classes that contain only static methods (code smell in
  Dart/Flutter style guide). Use top-level constants and functions instead.

Where to find implementations

- SettingsBloc: lib/application_services/settings_bloc.dart
- NewsBloc (loading + regeneration + caching):
  lib/application_services/blocs/news_bloc.dart
- News checksum helper: lib/application_services/blocs/news_helpers.dart
- SharedPreferences usage for cache: inside NewsBloc in the RegenerateInsight
  handler
- Widget code (reads widget_style): macos/NewsWidgets/NewsWidgets.swift,
  ios/NewsWidgets/NewsWidgets.swift,
  android/app/src/main/java/com/turskyi/news_glance/NewsWidget.kt
- Settings persistence: lib/application_services/settings_service.dart
- Centralized storage keys: lib/res/storage_keys.dart
