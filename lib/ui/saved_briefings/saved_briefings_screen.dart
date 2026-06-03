import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/saved_briefings_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/ui/saved_briefings/empty_saved_briefings_widget.dart';
import 'package:news_glance/ui/saved_briefings/saved_briefing_card.dart';

class SavedBriefingsScreen extends StatelessWidget {
  const SavedBriefingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n?.savedInsights ?? 'Saved Insights',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: constants.maxContentWidth,
            ),
            child: BlocBuilder<SavedBriefingsBloc, SavedBriefingsState>(
              builder: (BuildContext _, SavedBriefingsState state) {
                if (state is SavedBriefingsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (state is SavedBriefingsLoaded) {
                  if (state.briefings.isEmpty) {
                    return const EmptySavedBriefingsWidget();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: state.briefings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SavedBriefingCard(
                          briefing: state.briefings[index],
                        );
                      },
                    );
                  }
                } else if (state is SavedBriefingError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
