import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/l10n/app_localizations.dart';

class WidgetSettings extends StatefulWidget {
  const WidgetSettings({super.key});

  @override
  State<WidgetSettings> createState() => _WidgetSettingsState();
}

class _WidgetSettingsState extends State<WidgetSettings> {
  bool _isSaving = false;
  bool _isRequestPinWidgetSupported = false;

  @override
  void initState() {
    super.initState();
    _checkPinWidgetSupport();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    } else {
      return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          final TextTheme textTheme = Theme.of(context).textTheme;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!kIsWeb) ...<Widget>[
                RadioGroup<int>(
                  groupValue: state.widgetUpdateFrequency,
                  onChanged: _onFrequencyChanged,
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
                            fontSize: textTheme.titleLarge?.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.chooseFrequency,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RadioListTile<int>(
                        title: Text(l10n.every4Hours),
                        value: 240,
                        enabled: !_isSaving,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      RadioListTile<int>(
                        title: Text(l10n.every12Hours),
                        value: 720,
                        enabled: !_isSaving,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      RadioListTile<int>(
                        title: Text(l10n.onceDaily),
                        value: 1440,
                        enabled: !_isSaving,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
              // Conclusion UI selection
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  l10n.conclusionStyle,
                  style: TextStyle(
                    fontSize: textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              RadioGroup<int>(
                groupValue: state.style.index,
                onChanged: _onConclusionStyleChanged,
                child: Column(
                  children: <Widget>[
                    RadioListTile<int>(
                      title: Text(l10n.insight),
                      value: 0,
                      enabled: !_isSaving,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    RadioListTile<int>(
                      title: Text(l10n.conclusion),
                      value: 1,
                      enabled: !_isSaving,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    RadioListTile<int>(
                      title: Text(l10n.summary),
                      value: 2,
                      enabled: !_isSaving,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isRequestPinWidgetSupported) ...<Widget>[
                _PinWidgetSection(l10n: l10n),
              ],
            ],
          );
        },
      );
    }
  }

  Future<void> _checkPinWidgetSupport() async {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      final bool? isSupported = await HomeWidget.isRequestPinWidgetSupported();
      if (mounted) {
        setState(() {
          _isRequestPinWidgetSupported = isSupported ?? false;
        });
      }
    }
  }

  void _onConclusionStyleChanged(int? value) {
    if (value != null) {
      _saveConclusionStyle(value);
    }
  }

  void _onFrequencyChanged(int? value) {
    if (value != null) {
      _saveFrequency(value);
    }
  }

  Future<void> _saveFrequency(int frequency) async {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      context.read<SettingsBloc>().add(
        SetWidgetUpdateFrequencyEvent(frequency),
      );

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
}

class _PinWidgetSection extends StatelessWidget {
  const _PinWidgetSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            l10n.pinWidget,
            style: TextStyle(
              fontSize: textTheme.titleLarge?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.pinWidgetDescription, style: textTheme.bodySmall),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => HomeWidget.requestPinWidget(
                qualifiedAndroidName: 'com.turskyi.news_glance.NewsWidget',
              ),
              icon: const Icon(Icons.push_pin_outlined),
              label: Text(l10n.pinWidget),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
