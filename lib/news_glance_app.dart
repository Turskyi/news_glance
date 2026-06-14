import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';

class NewsGlanceApp extends StatelessWidget {
  const NewsGlanceApp({
    required this._routes,
    required this._theme,
    required this._darkTheme,
    required this._settingsBloc,
    required this._savedBriefingsBloc,
    required this._savedNewsBloc,
    super.key,
  });

  final Map<String, WidgetBuilder> _routes;
  final ThemeData _theme;
  final ThemeData _darkTheme;
  final SettingsBloc _settingsBloc;
  final SavedBriefingsBloc _savedBriefingsBloc;
  final SavedNewsBloc _savedNewsBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SettingsBloc>.value(value: _settingsBloc),
        BlocProvider<SavedBriefingsBloc>.value(value: _savedBriefingsBloc),
        BlocProvider<SavedNewsBloc>.value(value: _savedNewsBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          if (!state.isLoaded) {
            return const SizedBox.shrink();
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: constants.appName,
            initialRoute: state.isOnboardingCompleted
                ? AppRoute.home.path
                : AppRoute.onboarding.path,
            routes: _routes,
            theme: _theme,
            darkTheme: _darkTheme,
            themeMode: state.themeMode,
            locale: state.locale.value,
            localizationsDelegates: const <LocalizationsDelegate<Object>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
