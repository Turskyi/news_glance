import 'package:news_glance/application_services/home_widget_service_impl.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/domain_services/home_widget_service.dart';
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<void> setConclusionUiStyle(ConclusionUiStyle style) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(storage_keys.conclusionUiStyle, style.index);
    // Also save widget_style via home widget service for platform widgets
    const HomeWidgetService homeWidgetService = HomeWidgetServiceImpl();
    final String widgetStyle = style == ConclusionUiStyle.insight
        ? 'insight'
        : 'conclusion';
    await homeWidgetService.setWidgetStyle(widgetStyle);
  }

  Future<ConclusionUiStyle> getConclusionUiStyle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(storage_keys.conclusionUiStyle);

    if (raw == null || raw < 0 || raw >= ConclusionUiStyle.values.length) {
      return ConclusionUiStyle.insight;
    } else {
      return ConclusionUiStyle.values[raw];
    }
  }
}
