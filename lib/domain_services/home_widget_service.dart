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

  /// Update home widget with headline data
  Future<void> updateHomeWidget({
    required String headlineTitle,
    required String headlineDescription,
    int? widgetUpdateFrequencyMinutes,
  });

  /// Set widget update frequency in minutes
  /// The widget will use this to determine refresh intervals
  Future<bool?> setWidgetUpdateFrequency(int frequencyMinutes);
}
