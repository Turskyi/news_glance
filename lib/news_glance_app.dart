import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';

class NewsGlanceApp extends StatelessWidget {
  const NewsGlanceApp({
    required this._routes,
    required this._theme,
    required this._settingsBloc,
    super.key,
  });

  final Map<String, WidgetBuilder> _routes;
  final ThemeData _theme;
  final SettingsBloc _settingsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>.value(
      value: _settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: constants.appName,
            initialRoute: AppRoute.home.path,
            routes: _routes,
            theme: _theme,
            locale: state.locale,
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
