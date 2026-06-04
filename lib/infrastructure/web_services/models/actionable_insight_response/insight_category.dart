import 'package:news_glance/l10n/app_localizations.dart';

enum InsightCategory {
  travel('TRAVEL'),
  finance('FINANCE'),
  safety('SAFETY'),
  health('HEALTH'),
  lifestyle('LIFESTYLE'),
  general('GENERAL');

  factory InsightCategory.fromString(String value) {
    return InsightCategory.values.firstWhere(
      (InsightCategory category) => category.value == value,
      orElse: () => InsightCategory.general,
    );
  }

  const InsightCategory(this.value);

  final String value;

  String localizedName(AppLocalizations? l10n) {
    switch (this) {
      case InsightCategory.travel:
        return l10n?.travelCategory ?? value;
      case InsightCategory.finance:
        return l10n?.financeCategory ?? value;
      case InsightCategory.safety:
        return l10n?.safetyCategory ?? value;
      case InsightCategory.health:
        return l10n?.healthCategory ?? value;
      case InsightCategory.lifestyle:
        return l10n?.lifestyleCategory ?? value;
      case InsightCategory.general:
        return l10n?.generalCategory ?? value;
    }
  }
}
