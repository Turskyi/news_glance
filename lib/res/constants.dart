const String iOSWidgetName = 'NewsWidgets';
const String androidWidgetName = 'NewsWidget';
const String appGroupId = 'group.dmytrowidget';
const String developerDomain = 'turskyi.com';
const String domain = 'newsglanceai.com';

/// Change it to `const String baseUrl = 'http://localhost:3000/api/';` when
/// running the backend locally.
const String baseUrl = 'https://news.$domain/api/';
const String usaCode = 'US';
const String internationalCode = 'intl';
const String website = 'https://news.$domain';
const String email = 'support@$domain';
const String phone = '+14379852581';
const String address =
    'Harmony Village\n3035 Finch West Avenue.,\nNorth York\nOntario\n'
    'M9M 0A3\nCanada.';
const int newsMax = 12;
const double defaultExpandedHeight = 278.0;
const String appName = 'News Glance';
const double maxContentWidth = 800.0;

/// Home Widget Method Channel
const String homeWidgetMethodChannel = 'com.newsglance.home_widget';
const String setAppGroupIdMethod = 'setAppGroupId';
const String saveWidgetDataMethod = 'saveWidgetData';
const String getWidgetDataMethod = 'getWidgetData';
const String updateWidgetMethod = 'updateWidget';
const String appGroupIdArgKey = 'appGroupId';
const String keyArgKey = 'key';
const String valueArgKey = 'value';

/// 24 hours
const int defaultWidgetUpdateFrequencyMinutes = 1440;
const int minWidgetUpdateFrequencyMinutes = 30;

/// Minimum minutes between manual refreshes shown to the user
const int manualRefreshMinMinutes = 30;
const int insightMaxLines = 20;
