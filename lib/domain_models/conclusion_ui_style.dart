enum ConclusionUiStyle {
  insight,
  conclusion;

  bool get isConclusion => this == ConclusionUiStyle.conclusion;

  bool get isInsight => this == ConclusionUiStyle.insight;
}
