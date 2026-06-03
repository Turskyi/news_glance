import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:news_glance/application_services/blocs/saved_news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/ui/saved_news/saved_news_screen.dart';

class SavedNewsRouteWrapper extends StatelessWidget {
  const SavedNewsRouteWrapper({
    required this.savedNewsBloc,
    required this.settingsBloc,
    super.key,
  });

  final SavedNewsBloc savedNewsBloc;
  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SavedNewsBloc>.value(value: savedNewsBloc),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
      ],
      child: const SavedNewsScreen(),
    );
  }
}
