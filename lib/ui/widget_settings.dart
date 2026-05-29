import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/home_widget_service_impl.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;

class WidgetSettings extends StatefulWidget {
  const WidgetSettings({super.key});

  @override
  State<WidgetSettings> createState() => _WidgetSettingsState();
}

class _WidgetSettingsState extends State<WidgetSettings> {
  int _selectedFrequency = constants.defaultWidgetUpdateFrequencyMinutes;
  bool _isSaving = false;
  final HomeWidgetService _homeWidgetService = const HomeWidgetServiceImpl();

  @override
  void initState() {
    super.initState();
    _loadCurrentFrequency();
  }

  Future<void> _loadCurrentFrequency() async {
    final int freq = await _homeWidgetService.getWidgetUpdateFrequency();
    if (mounted) {
      setState(() => _selectedFrequency = freq);
    }
  }

  Future<void> _saveFrequency(int frequency) async {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      await _homeWidgetService.setWidgetUpdateFrequency(frequency);
      setState(() => _selectedFrequency = frequency);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getFrequencyLabel(l10n, frequency),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveConclusionStyle(int selection) async {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      final ConclusionUiStyle style = ConclusionUiStyle.values[selection];

      // Persist via SettingsBloc
      try {
        context.read<SettingsBloc>().add(SetConclusionStyleEvent(style));
      } catch (_) {}

      // Ask NewsBloc to regenerate insight for current news without re-fetching
      try {
        context.read<NewsBloc>().add(RegenerateInsightEvent(style));
      } catch (_) {}

      if (mounted) {
        late final String label;
        switch (selection) {
          case 0:
            label = l10n.usingInsight;
          case 1:
            label = l10n.usingConclusion;
          case 2:
            label = l10n.usingSummary;
          default:
            label = '';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(label, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _getFrequencyLabel(AppLocalizations l10n, int minutes) {
    String label = '';
    if (minutes == 240) {
      label = l10n.every4Hours;
    } else if (minutes == 720) {
      label = l10n.every12Hours;
    } else if (minutes == 1440) {
      label = l10n.onceDaily;
    }

    if (label.isNotEmpty) {
      return l10n.frequencySetTo(label);
    }
    return l10n.frequencyChanged;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioGroup<int>(
          groupValue: _selectedFrequency,
          onChanged: (int? value) {
            if (value != null) {
              _saveFrequency(value);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  l10n.widgetUpdateFrequency,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.chooseFrequency,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              RadioListTile<int>(
                title: Text(l10n.every4Hours),
                value: 240,
                enabled: !_isSaving,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              RadioListTile<int>(
                title: Text(l10n.every12Hours),
                value: 720,
                enabled: !_isSaving,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              RadioListTile<int>(
                title: Text(l10n.onceDaily),
                value: 1440,
                enabled: !_isSaving,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const Divider(),
            ],
          ),
        ),
        // Conclusion UI selection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            l10n.conclusionStyle,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState s) {
            final ConclusionUiStyle style = s.style;
            return RadioGroup<int>(
              groupValue: style.index,
              onChanged: (int? value) {
                if (value != null) {
                  _saveConclusionStyle(value);
                }
              },
              child: Column(
                children: <Widget>[
                  RadioListTile<int>(
                    title: Text(l10n.insight),
                    value: 0,
                    enabled: !_isSaving,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.conclusion),
                    value: 1,
                    enabled: !_isSaving,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<int>(
                    title: Text(l10n.summary),
                    value: 2,
                    enabled: !_isSaving,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}
