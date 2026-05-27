import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/home_widget_service_impl.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/ui/widget_frequency_option.dart';

class WidgetSettings extends StatefulWidget {
  const WidgetSettings({super.key});

  @override
  State<WidgetSettings> createState() => _WidgetSettingsState();
}

class _WidgetSettingsState extends State<WidgetSettings> {
  static const List<WidgetFrequencyOption> _frequencyOptions =
      <WidgetFrequencyOption>[
        WidgetFrequencyOption(label: 'Every 4 hours', minutes: 240),
        WidgetFrequencyOption(label: 'Every 12 hours', minutes: 720),
        WidgetFrequencyOption(label: 'Once daily (default)', minutes: 1440),
      ];

  int _selectedFrequency = constants.defaultWidgetUpdateFrequencyMinutes;
  bool _isSaving = false;
  final HomeWidgetService _homeWidgetService = const HomeWidgetServiceImpl();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveFrequency(int frequency) async {
    setState(() => _isSaving = true);
    try {
      await _homeWidgetService.setWidgetUpdateFrequency(frequency);
      setState(() => _selectedFrequency = frequency);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getFrequencyLabel(frequency),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              selection == 0 ? 'Using Insight' : 'Using Conclusion',
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

  String _getFrequencyLabel(int minutes) {
    for (final WidgetFrequencyOption option in _frequencyOptions) {
      if (option.minutes == minutes) {
        return 'Widget update frequency set to: ${option.label}';
      }
    }
    return 'Widget update frequency changed';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioGroup<int>(
          groupValue: _selectedFrequency,
          onChanged: (int? value) {
            if (value != null) {
              _saveFrequency(value);
            } else {
              // Deselection is not supported.
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
                  'Widget Update Frequency',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Choose how often the News Glance widget updates in '
                  'Notification Center',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              ...<Widget>[
                for (final WidgetFrequencyOption option in _frequencyOptions)
                  RadioListTile<int>(
                    title: Text(option.label),
                    value: option.minutes,
                    enabled: !_isSaving,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
              ],
              const Divider(),
            ],
          ),
        ),
        // Conclusion UI selection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Conclusion Style',
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
                } else {
                  // Deselection is not supported.
                }
              },
              child: Column(
                children: <Widget>[
                  RadioListTile<int>(
                    title: const Text('Insight'),
                    value: 0,
                    enabled: !_isSaving,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<int>(
                    title: const Text('Conclusion'),
                    value: 1,
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
