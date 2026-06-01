import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:news_glance/application_services/blocs/search_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/ui/search_page.dart';

class SearchRouteWrapper extends StatelessWidget {
  const SearchRouteWrapper({
    required this.searchBloc,
    required this.settingsBloc,
    super.key,
  });

  final SearchBloc searchBloc;
  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SearchBloc>.value(value: searchBloc),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
      ],
      child: const SearchPage(),
    );
  }
}
