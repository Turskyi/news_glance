enum ActionableInsightLevel {
  critical('CRITICAL'),
  warning('WARNING'),
  advisory('ADVISORY'),
  neutral('NEUTRAL');

  factory ActionableInsightLevel.fromString(String value) {
    return ActionableInsightLevel.values.firstWhere(
      (ActionableInsightLevel level) => level.value == value,
      orElse: () => ActionableInsightLevel.neutral,
    );
  }

  const ActionableInsightLevel(this.value);

  final String value;
}
