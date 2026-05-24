const String iOSWidgetName = 'NewsWidgets';
const String androidWidgetName = 'NewsWidget';
const String appGroupId = 'group.dmytrowidget';
const String developerDomain = 'turskyi.com';
const String baseUrl = 'https://news.$developerDomain/api/';
const String usaCode = 'US';
const String internationalCode = 'intl';
const String website = 'https://news.$developerDomain';
const String email = 'dmytro@$developerDomain';
const String phone = '+14379852581';
const String address =
    'Address:\nHarmony Village\n3035 Finch West Avenue.,\nNorth York\nOntario\n'
    'M9M 0A3\nCanada.';
const int newsMax = 10;
const double defaultExpandedHeight = 278.0;
const String appName = 'News Glance';

/// Home Widget Method Channel
const String homeWidgetMethodChannel = 'com.newsglance.home_widget';
const String setAppGroupIdMethod = 'setAppGroupId';
const String saveWidgetDataMethod = 'saveWidgetData';
const String updateWidgetMethod = 'updateWidget';
const String appGroupIdArgKey = 'appGroupId';

/// Widget Update Frequency
const String widgetUpdateFrequencyKey = 'news_glance_widget_update_frequency';

/// 24 hours
const int defaultWidgetUpdateFrequencyMinutes = 1440;
const int minWidgetUpdateFrequencyMinutes = 30;
