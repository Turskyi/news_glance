import 'package:flutter/material.dart';
import 'package:news_glance/application_services/home_widget_service_impl.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/res/constants.dart' as constants;

/// Widget frequency options displayed to users
class WidgetFrequencyOption {
  const WidgetFrequencyOption({required this.label, required this.minutes});

  final String label;
  final int minutes;
}

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            ListTile(
              // ignore: deprecated_member_use
              title: Text(option.label),
              // ignore: deprecated_member_use
              leading: Radio<int>(
                value: option.minutes,
                // ignore: deprecated_member_use
                groupValue: _selectedFrequency,
                // ignore: deprecated_member_use
                onChanged: _isSaving
                    ? null
                    : (int? value) {
                        if (value != null) {
                          _saveFrequency(value);
                        }
                      },
              ),
              enabled: !_isSaving,
            ),
        ],
        const Divider(),
      ],
    );
  }
}
