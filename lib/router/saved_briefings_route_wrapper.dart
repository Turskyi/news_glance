import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/ui/saved_briefings/saved_briefings_screen.dart';

class SavedBriefingsRouteWrapper extends StatelessWidget {
  const SavedBriefingsRouteWrapper({
    required this.savedBriefingsBloc,
    required this.settingsBloc,
    super.key,
  });

  final SavedBriefingsBloc savedBriefingsBloc;
  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SavedBriefingsBloc>.value(value: savedBriefingsBloc),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
      ],
      child: const SavedBriefingsScreen(),
    );
  }
}
