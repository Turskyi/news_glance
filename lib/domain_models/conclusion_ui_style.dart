enum ConclusionUiStyle {
  insight,
  conclusion,
  summary;

  bool get isConclusion => this == ConclusionUiStyle.conclusion;

  bool get isInsight => this == ConclusionUiStyle.insight;

  bool get isSummary => this == ConclusionUiStyle.summary;
}
