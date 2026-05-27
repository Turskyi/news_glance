import 'package:flutter/material.dart';
import 'package:news_glance/application_services/settings_service.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/ui/markdown_preview.dart';
import 'package:news_glance/ui/news_conclusion_section.dart';
import 'package:news_glance/ui/signal_card_style.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({required this.insight, super.key});

  final ActionableInsight insight;

  SignalCardStyle _getSignalStyles(ActionableInsightLevel level) {
    switch (level) {
      case ActionableInsightLevel.critical:
        return const SignalCardStyle(
          backgroundColor: Color(0xFFFEF2F2),
          borderColor: Color(0xFFEF4444),
          textColor: Color(0xFF991B1B),
          lightColor: Color(0xFFEF4444),
          icon: '🚨',
          label: 'CRITICAL ACTION',
        );
      case ActionableInsightLevel.warning:
        return const SignalCardStyle(
          backgroundColor: Color(0xFFFFFBEB),
          borderColor: Color(0xFFF59E0B),
          textColor: Color(0xFFB45309),
          lightColor: Color(0xFFF59E0B),
          icon: '⚠️',
          label: 'WARNING',
        );
      case ActionableInsightLevel.advisory:
        return const SignalCardStyle(
          backgroundColor: Color(0xFFEFF6FF),
          borderColor: Color(0xFF3B82F6),
          textColor: Color(0xFF1D4ED8),
          lightColor: Color(0xFF3B82F6),
          icon: 'ℹ️',
          label: 'ADVISORY',
        );
      case ActionableInsightLevel.neutral:
        return const SignalCardStyle(
          backgroundColor: Color(0xFFECFDF5),
          borderColor: Color(0xFF10B981),
          textColor: Color(0xFF047857),
          lightColor: Color(0xFF10B981),
          icon: '✅',
          label: 'ALL CLEAR',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignalCardStyle styles = _getSignalStyles(insight.level);
    final bool isHighRisk =
        insight.level != ActionableInsightLevel.neutral &&
        insight.probability >= 0.8;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: insight.conclusion.trim().isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                color: styles.backgroundColor,
                border: Border.all(color: styles.borderColor, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            styles.icon,
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 9.6,
                                  height: 9.6,
                                  decoration: BoxDecoration(
                                    color: styles.lightColor,
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: styles.lightColor.withValues(
                                          alpha: 0.6,
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 9.6),
                                Text(
                                  styles.label,
                                  style: TextStyle(
                                    color: styles.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.4,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.6),
                            if (insight.level !=
                                ActionableInsightLevel.neutral) ...<Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '${insight.category.value} • '
                                      '${(insight.probability * 100).toInt()}% '
                                      'Probability',
                                      style: TextStyle(
                                        fontSize: 12.8,
                                        color: isHighRisk
                                            ? const Color(0xFFE11D48)
                                            : const Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...<Widget>[
                              Text(
                                'No immediate action required',
                                style: TextStyle(
                                  fontSize: 12.8,
                                  color: Colors.black.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FutureBuilder<ConclusionUiStyle>(
                    future: SettingsService().getConclusionUiStyle(),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<ConclusionUiStyle> snap,
                        ) {
                          final ConclusionUiStyle style =
                              snap.data ?? ConclusionUiStyle.insight;
                          final Color textColor = styles.textColor;
                          if (style == ConclusionUiStyle.conclusion) {
                            return NewsConclusionSection(
                              conclusion: insight.conclusion,
                              textColor: textColor,
                            );
                          }
                          return MarkdownPreview(
                            text: insight.conclusion.trim(),
                            color: textColor,
                          );
                        },
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
