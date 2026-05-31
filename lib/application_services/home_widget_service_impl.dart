import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/res/storage_keys.dart' as storage_keys;

@LazySingleton(as: HomeWidgetService)
class HomeWidgetServiceImpl implements HomeWidgetService {
  const HomeWidgetServiceImpl();

  static const MethodChannel _widgetChannel = MethodChannel(
    constants.homeWidgetMethodChannel,
  );

  @override
  Future<void> setAppGroupId(String appGroupId) {
    if (kIsWeb) {
      return Future<void>.value();
    }
    if (Platform.isMacOS) {
      debugPrint(
        'HomeWidgetService setAppGroupId: macOS channel call '
        '(appGroupId=$appGroupId).',
      );
      return _widgetChannel.invokeMethod<void>(
        constants.setAppGroupIdMethod,
        <String, String>{constants.appGroupIdArgKey: appGroupId},
      );
    } else {
      return HomeWidget.setAppGroupId(appGroupId);
    }
  }

  @override
  Future<bool?> saveWidgetData<T>(String id, T? data) {
    if (kIsWeb) {
      return Future<bool?>.value(false);
    }
    if (Platform.isMacOS) {
      debugPrint(
        'HomeWidgetService saveWidgetData: macOS channel call '
        '(key=$id, type=${data.runtimeType}).',
      );
      return _widgetChannel.invokeMethod<bool>(
        constants.saveWidgetDataMethod,
        <String, Object?>{
          'key': id,
          'value': data,
          constants.appGroupIdArgKey: constants.appGroupId,
        },
      );
    } else {
      return HomeWidget.saveWidgetData<T>(id, data);
    }
  }

  @override
  Future<bool?> updateWidget({
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) {
    if (kIsWeb) {
      return Future<bool?>.value(false);
    }
    if (Platform.isMacOS) {
      debugPrint('HomeWidgetService updateWidget: macOS channel call.');
      return _widgetChannel.invokeMethod<bool>(constants.updateWidgetMethod);
    } else {
      return HomeWidget.updateWidget(
        androidName: androidName,
        iOSName: iOSName,
        qualifiedAndroidName: qualifiedAndroidName,
      );
    }
  }

  @override
  Future<void> updateHomeWidget({
    required String headlineTitle,
    required String headlineDescription,
    int? widgetUpdateFrequencyMinutes,
  }) async {
    debugPrint(
      'HomeWidgetService updateHomeWidget: start '
      '(title=$headlineTitle, frequency=${widgetUpdateFrequencyMinutes}min).',
    );

    // Set app group ID
    await setAppGroupId(constants.appGroupId);

    // Save headline title
    await saveWidgetData<String>(storage_keys.headlineTitle, headlineTitle);

    // Save headline description
    if (headlineDescription.isNotEmpty) {
      await saveWidgetData<String>(
        storage_keys.headlineDescription,
        headlineDescription,
      );
    }

    // Save widget update frequency if provided
    if (widgetUpdateFrequencyMinutes != null &&
        widgetUpdateFrequencyMinutes > 0) {
      final int frequency =
          widgetUpdateFrequencyMinutes <
              constants.minWidgetUpdateFrequencyMinutes
          ? constants.minWidgetUpdateFrequencyMinutes
          : widgetUpdateFrequencyMinutes;
      await saveWidgetData<int>(storage_keys.widgetUpdateFrequency, frequency);
    }

    // Update the widget
    await updateWidget(
      iOSName: constants.iOSWidgetName,
      androidName: constants.androidWidgetName,
    );

    debugPrint('HomeWidgetService updateHomeWidget: completed.');
  }

  @override
  Future<void> updateHomeWidgetWithSignal({
    required ActionableInsight insight,
    int? widgetUpdateFrequencyMinutes,
  }) async {
    debugPrint(
      'HomeWidgetService updateHomeWidgetWithSignal: start '
      '(level=${insight.level}, frequency=${widgetUpdateFrequencyMinutes}min).',
    );

    // Set app group ID
    await setAppGroupId(constants.appGroupId);

    // Save signal data
    await saveWidgetData<String>(storage_keys.signalLevel, insight.level.value);
    await saveWidgetData<String>(
      storage_keys.signalConclusion,
      insight.conclusion,
    );
    await saveWidgetData<int>(
      storage_keys.signalProbability,
      (insight.probability * 100).toInt(),
    );
    await saveWidgetData<String>(
      storage_keys.signalCategory,
      insight.category.value,
    );

    // Save widget update frequency if provided
    if (widgetUpdateFrequencyMinutes != null &&
        widgetUpdateFrequencyMinutes > 0) {
      final int frequency =
          widgetUpdateFrequencyMinutes <
              constants.minWidgetUpdateFrequencyMinutes
          ? constants.minWidgetUpdateFrequencyMinutes
          : widgetUpdateFrequencyMinutes;
      await saveWidgetData<int>(storage_keys.widgetUpdateFrequency, frequency);
    }

    // Update the widget
    await updateWidget(
      iOSName: constants.iOSWidgetName,
      androidName: constants.androidWidgetName,
    );

    debugPrint('HomeWidgetService updateHomeWidgetWithSignal: completed.');
  }

  /// Save widget update frequency independently
  /// This allows the frequency to be changed without updating widget content
  @override
  Future<bool?> setWidgetUpdateFrequency(int frequencyMinutes) async {
    final int frequency =
        frequencyMinutes < constants.minWidgetUpdateFrequencyMinutes
        ? constants.minWidgetUpdateFrequencyMinutes
        : frequencyMinutes;
    debugPrint(
      'HomeWidgetService setWidgetUpdateFrequency: $frequency minutes '
      '(requested: $frequencyMinutes).',
    );
    return saveWidgetData<int>(storage_keys.widgetUpdateFrequency, frequency);
  }

  /// Save widget style preference for platform widgets to read
  @override
  Future<bool?> setWidgetStyle(String style) async {
    debugPrint('HomeWidgetService setWidgetStyle: $style.');
    return saveWidgetData<String>('widget_style', style);
  }

  @override
  Future<int> getWidgetUpdateFrequency() async {
    try {
      if (kIsWeb) {
        return constants.defaultWidgetUpdateFrequencyMinutes;
      }
      if (Platform.isMacOS) {
        final dynamic result = await _widgetChannel
            .invokeMethod<dynamic>('getWidgetData', <String, Object?>{
              'key': storage_keys.widgetUpdateFrequency,
              constants.appGroupIdArgKey: constants.appGroupId,
            });
        if (result == null) {
          return constants.defaultWidgetUpdateFrequencyMinutes;
        }
        if (result is int) return result;
        if (result is String) {
          return int.tryParse(result) ??
              constants.defaultWidgetUpdateFrequencyMinutes;
        }
        return constants.defaultWidgetUpdateFrequencyMinutes;
      } else {
        final dynamic result = await HomeWidget.getWidgetData(
          storage_keys.widgetUpdateFrequency,
        );
        if (result == null) {
          return constants.defaultWidgetUpdateFrequencyMinutes;
        }
        if (result is int) return result;
        if (result is String) {
          return int.tryParse(result) ??
              constants.defaultWidgetUpdateFrequencyMinutes;
        }
        return constants.defaultWidgetUpdateFrequencyMinutes;
      }
    } catch (_) {
      return constants.defaultWidgetUpdateFrequencyMinutes;
    }
  }
}
