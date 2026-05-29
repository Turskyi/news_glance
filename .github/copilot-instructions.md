# Copilot Instructions for News Glance

## Quick Reference

**Language**: Dart | **Framework**: Flutter | **Architecture**: Onion
Architecture | **State Management**: BLoC

---

## Build, Test & Lint Commands

### Setup & Code Generation

```bash
# Generate required files (run after pulling or modifying models/APIs)
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# Get dependencies
flutter pub get
```

### Building

```bash
# Debug build for device
flutter run

# Web debug (disables CORS for local development only)
flutter run -d chrome --web-browser-flag "--disable-web-security"

# Release build for platform
flutter build apk           # Android
flutter build ipa           # iOS
flutter build web --release # Web
```

### Testing

```bash
# Run all tests
flutter test --coverage --test-randomize-ordering-seed random
```

### Linting & Code Quality

```bash
# Check for lint errors
flutter analyze .

# Check format without changes
dart format --set-exit-if-changed .
```

---

## Architecture Overview

This project follows **Onion Architecture** with clear layer separation:

### Layer Structure (inside out)

1. **Domain Models** (`lib/domain_models/`) - Pure data classes, enums,
   exceptions. No dependencies on outer layers.
    - `news_article.dart` - Core domain entity
    - `actionable_insight.dart` - AI-generated insights
    - `conclusion_ui_style.dart` - UI styling enum

2. **Domain Services** (`lib/domain_services/`) - Repository interfaces only.
   Define contracts for data access.
    - `news_repository.dart` - Interface for news data access

3. **Application Services** (`lib/application_services/`) - Business logic layer
   with BLoCs and services
    - **BLoCs** (`blocs/`) - Handle events, emit states, orchestrate business
      logic
        - `NewsBloc` - Manages news fetching, caching, and insight regeneration
        - `SettingsBloc` - Manages user settings and UI preferences
    - **Repositories** (`repositories/`) - Implement domain service interfaces
    - `settings_service.dart` - Shared preferences management

4. **Infrastructure** (`lib/infrastructure/`) - External integrations
    - `web_services/rest/` - REST API client (Retrofit/Dio)
    - `web_services/models/` - API response models

5. **UI & Router** (`lib/ui/`, `lib/router/`) - Presentation layer
    - `routes.dart` - Route configuration
    - UI screens and widgets

### Dependency Flow

Dependencies point **inward** toward the core. Outer layers depend on inner
layers, never reversed.

---

## Key Conventions

### BLoC Patterns (Both news bloc and settings bloc)

- **Bloc over Cubit**: Use `Bloc<Event, State>` for cross-component state
  driving UI and side effects (as per `AI_GUARDRAILS.md`)
  ```

### Caching Strategy (AI-aware)

- **Cache AI outputs per checksum**: News articles are hashed; if content hasn't
  changed, reuse cached AI insights
- **Use SharedPreferences with centralized keys**: All cache keys defined in
  `lib/res/storage_keys.dart`
- **Avoid unnecessary re-fetches**: When switching UI styles (e.g., "insight"
  vs "conclusion"), only regenerate AI if missing or news changed

### Home Widget Integration

- Read `widget_style` from SharedPreferences/app group
- Write widget payloads with `widget_style` and news checksum
- Platform-specific implementations:
    - Android: `android/app/src/main/java/com/turskyi/news_glance/NewsWidget.kt`
    - iOS: `ios/NewsWidgets/NewsWidgets.swift`
    - macOS: `macos/NewsWidgets/NewsWidgets.swift`

### Naming Conventions

- **Avoid classes with only static members**: Use top-level functions and
  constants instead (per `analysis_options.yaml`)

### Code Style Enforcements (from analysis_options.yaml)

- **Trailing commas**: Required for multi-line function calls and definitions
- **Single quotes**: Prefer `'string'` over `"string"`
- **Always specify types**: No `var` in public APIs
- **Line length**: Max 80 characters (`lines_longer_than_80_chars` enabled)
- **Const constructors**: Prefer `const` for immutable objects
- **Avoid avoid_as**: Don't cast nullable to non-nullable; use type checking
- **Avoid deprecated Color methods**: Use `.withValues(alpha: ...)` instead of
  `.withOpacity(...)` to avoid precision loss.

### Dependency Injection (GetIt + Injectable)

- All injectables must use `@injectable` annotation
- DI configuration in `lib/di/injector.dart` and auto-generated
  `injector.config.dart`
- Initialize DI in `main()`:
  ```dart
  final GetIt dependencies = di.injectDependencies();
  final NewsBloc newsBloc = dependencies.get<NewsBloc>();
  ```
- Module for REST client in `rest_client_module.dart`

### Localization (intl)

- ARB files in `lib/l10n/` (e.g., `app_en.arb`)
- Configuration in `l10n.yaml`
- **Crucial**: After adding keys to ARB files, run `flutter gen-l10n` to update
  `AppLocalizations` getters

### Code Generation (Build Runner)

- Triggers for: BLoC serialization, JSON models, Retrofit clients, injectable DI
- Run after any changes to annotated classes

---

## Important Files & Guardrails

See `AI_GUARDRAILS.md` for:

- Enforced BLoC usage for cross-component state
- Cache invalidation rules
- Widget payload structure
- Storage key management

Key files:

- `lib/res/storage_keys.dart` - Centralized SharedPreferences keys
- `lib/res/constants.dart` - App-wide constants
- `lib/main.dart` - Entry point with DI setup (heavily commented)

---

## Workflows

## Common Pitfalls to Avoid

1. **Don't use Cubit for shared state**: Only use Bloc for cross-component or
   side-effect-heavy state
2. **Don't create static-only classes**: Violates linting rules; use top-level
   functions instead
3. **Don't forget to run code generation**: Both `build_runner` and
   `flutter gen-l10n` are required after model/API or ARB changes. Missing
   getters in `AppLocalizations` usually mean `gen-l10n` hasn't been run.
4. **Don't cast nullable to non-nullable**: Use type guards or null coalescing
   instead
5. **Don't exceed 80 character line length**: Format and break lines early
