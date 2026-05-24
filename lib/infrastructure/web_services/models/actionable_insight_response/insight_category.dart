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
}
