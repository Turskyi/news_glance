import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/res/constants.dart' as constants;

class HomeWidgetServiceImpl implements HomeWidgetService {
  const HomeWidgetServiceImpl();

  static const MethodChannel _widgetChannel = MethodChannel(
    constants.homeWidgetMethodChannel,
  );

  @override
  Future<void> setAppGroupId(String appGroupId) {
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
    await saveWidgetData<String>('headline_title', headlineTitle);

    // Save headline description
    if (headlineDescription.isNotEmpty) {
      await saveWidgetData<String>('headline_description', headlineDescription);
    }

    // Save widget update frequency if provided
    if (widgetUpdateFrequencyMinutes != null &&
        widgetUpdateFrequencyMinutes > 0) {
      final int frequency =
          widgetUpdateFrequencyMinutes <
              constants.minWidgetUpdateFrequencyMinutes
          ? constants.minWidgetUpdateFrequencyMinutes
          : widgetUpdateFrequencyMinutes;
      await saveWidgetData<int>(constants.widgetUpdateFrequencyKey, frequency);
    }

    // Update the widget
    await updateWidget(
      iOSName: constants.iOSWidgetName,
      androidName: constants.androidWidgetName,
    );

    debugPrint('HomeWidgetService updateHomeWidget: completed.');
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
    return saveWidgetData<int>(constants.widgetUpdateFrequencyKey, frequency);
  }
}
