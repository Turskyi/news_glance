import 'package:news_glance/domain_models/actionable_insight.dart';

abstract interface class HomeWidgetService {
  const HomeWidgetService();

  /// Set the App Group ID for widget data sharing
  Future<void> setAppGroupId(String appGroupId);

  /// Save [data] to the Widget Storage
  /// Returns whether the data was saved or not
  Future<bool?> saveWidgetData<T>(String id, T? data);

  /// Updates the HomeScreen Widget
  /// iOS Widgets will look for [iOSName]
  /// Android Widgets will look for [qualifiedAndroidName] then [androidName]
  Future<bool?> updateWidget({
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  });

  /// Update home widget with headline data (legacy)
  Future<void> updateHomeWidget({
    required String headlineTitle,
    required String headlineDescription,
    int? widgetUpdateFrequencyMinutes,
  });

  /// Update home widget with signal insight data
  Future<void> updateHomeWidgetWithSignal({
    required ActionableInsight insight,
    int? widgetUpdateFrequencyMinutes,
  });

  /// Set widget update frequency in minutes
  /// The widget will use this to determine refresh intervals
  Future<bool?> setWidgetUpdateFrequency(int frequencyMinutes);

  /// Save widget style preference ('insight' or 'conclusion')
  /// Platform widgets read this to display the appropriate style
  Future<bool?> setWidgetStyle(String style);
}
