import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/domain_models/conclusion_ui_style.dart';
import 'package:news_glance/infrastructure/web_services/models/actionable_insight_response/actionable_insight_level.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/insight_category_probability_label.dart';
import 'package:news_glance/ui/markdown_preview.dart';
import 'package:news_glance/ui/save_briefing_button.dart';
import 'package:news_glance/ui/signal_card_style.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({required this.insight, this.searchQuery, super.key});

  final ActionableInsight insight;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SizedBox.shrink();
    } else {
      const double iconBoxSize = 56.0;
      const double indicatorSize = 9.6;

      final SignalCardStyle styles = _getSignalStyles(
        context,
        l10n,
        insight.level,
      );
      final bool isHighRisk =
          insight.level != ActionableInsightLevel.neutral &&
          insight.probability >= 0.8;
      final ThemeData theme = Theme.of(context);
      final TextTheme textTheme = theme.textTheme;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: insight.conclusion.trim().isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: styles.backgroundColor,
                  border: Border.all(color: styles.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
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
                              style: TextStyle(
                                fontSize: textTheme.displaySmall?.fontSize,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: indicatorSize,
                                    height: indicatorSize,
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
                                  const SizedBox(width: 8),
                                  Text(
                                    styles.label,
                                    style: TextStyle(
                                      color: styles.textColor,
                                      fontSize: textTheme.titleSmall?.fontSize,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (insight.isNotNeutral) ...<Widget>[
                                InsightCategoryProbabilityLabel(
                                  insight: insight,
                                  isHighRisk: isHighRisk,
                                  styles: styles,
                                ),
                              ] else ...<Widget>[
                                Text(
                                  l10n.noImmediateActionRequired,
                                  style: TextStyle(
                                    fontSize: textTheme.labelMedium?.fontSize,
                                    color: styles.textColor.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SaveBriefingButton(
                          insight: insight,
                          type: ConclusionUiStyle.insight,
                          searchQuery: searchQuery,
                          color: styles.textColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: styles.textColor),
                          onPressed: () {
                            _shareBriefing(context);
                          },
                          tooltip: l10n.shareBriefing,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MarkdownPreview(
                      text: insight.conclusion.trim(),
                      color: styles.textColor,
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      );
    }
  }

  void _shareBriefing(BuildContext context) {
    context.read<NewsBloc>().add(ShareBriefingEvent(insight.conclusion));
  }

  SignalCardStyle _getSignalStyles(
    BuildContext context,
    AppLocalizations l10n,
    ActionableInsightLevel level,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    switch (level) {
      case ActionableInsightLevel.critical:
        return SignalCardStyle(
          backgroundColor: isDark
              ? const Color(0xFF450A0A)
              : const Color(0xFFFEF2F2),
          borderColor: const Color(0xFFEF4444),
          textColor: isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B),
          lightColor: const Color(0xFFEF4444),
          icon: '🚨',
          label: l10n.criticalAction,
        );
      case ActionableInsightLevel.warning:
        return SignalCardStyle(
          backgroundColor: isDark
              ? const Color(0xFF451A03)
              : const Color(0xFFFFFBEB),
          borderColor: const Color(0xFFF59E0B),
          textColor: isDark ? const Color(0xFFFEF3C7) : const Color(0xFFB45309),
          lightColor: const Color(0xFFF59E0B),
          icon: '⚠️',
          label: l10n.warning,
        );
      case ActionableInsightLevel.advisory:
        return SignalCardStyle(
          backgroundColor: isDark
              ? const Color(0xFF172554)
              : const Color(0xFFEFF6FF),
          borderColor: const Color(0xFF3B82F6),
          textColor: isDark ? const Color(0xFFDBEAFE) : const Color(0xFF1D4ED8),
          lightColor: const Color(0xFF3B82F6),
          icon: 'ℹ️',
          label: l10n.advisory,
        );
      case ActionableInsightLevel.neutral:
        return SignalCardStyle(
          backgroundColor: isDark
              ? const Color(0xFF064E3B)
              : const Color(0xFFECFDF5),
          borderColor: const Color(0xFF10B981),
          textColor: isDark ? const Color(0xFFD1FAE5) : const Color(0xFF047857),
          lightColor: const Color(0xFF10B981),
          icon: '✅',
          label: l10n.allClear,
        );
    }
  }
}
