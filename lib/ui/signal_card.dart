import 'package:flutter/material.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/ui/markdown_preview.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({required this.insight, super.key});

  final ActionableInsight insight;

  Map<String, dynamic> _getSignalStyles(ActionableInsightLevel level) {
    switch (level) {
      case ActionableInsightLevel.critical:
        return <String, dynamic>{
          'bg': const Color(0xFFFEF2F2),
          'border': const Color(0xFFEF4444),
          'text': const Color(0xFF991B1B),
          'light': const Color(0xFFEF4444),
          'icon': '🚨',
          'label': 'CRITICAL ACTION',
        };
      case ActionableInsightLevel.warning:
        return <String, dynamic>{
          'bg': const Color(0xFFFFFBEB),
          'border': const Color(0xFFF59E0B),
          'text': const Color(0xFFB45309),
          'light': const Color(0xFFF59E0B),
          'icon': '⚠️',
          'label': 'WARNING',
        };
      case ActionableInsightLevel.advisory:
        return <String, dynamic>{
          'bg': const Color(0xFFEFF6FF),
          'border': const Color(0xFF3B82F6),
          'text': const Color(0xFF1D4ED8),
          'light': const Color(0xFF3B82F6),
          'icon': 'ℹ️',
          'label': 'ADVISORY',
        };
      case ActionableInsightLevel.neutral:
        return <String, dynamic>{
          'bg': const Color(0xFFECFDF5),
          'border': const Color(0xFF10B981),
          'text': const Color(0xFF047857),
          'light': const Color(0xFF10B981),
          'icon': '✅',
          'label': 'ALL CLEAR',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> styles = _getSignalStyles(insight.level);
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
                color: styles['bg'] as Color,
                border: Border.all(color: styles['border'] as Color, width: 2),
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
                            styles['icon'] as String,
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
                                    color: styles['light'] as Color,
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: (styles['light'] as Color)
                                            .withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 9.6),
                                Text(
                                  styles['label'] as String,
                                  style: TextStyle(
                                    color: styles['text'] as Color,
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
                  MarkdownPreview(text: insight.conclusion.trim()),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
