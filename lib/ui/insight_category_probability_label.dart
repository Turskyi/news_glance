import 'package:flutter/widgets.dart';
import 'package:news_glance/domain_models/actionable_insight.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/ui/signal_card_style.dart';

class InsightCategoryProbabilityLabel extends StatelessWidget {
  const InsightCategoryProbabilityLabel({
    required this.insight,
    required this.isHighRisk,
    required this.styles,
    super.key,
  });

  final ActionableInsight insight;
  final bool isHighRisk;
  final SignalCardStyle styles;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${insight.category.localizedName(l10n)} • '
            '${(insight.probability * 100).toInt()}'
            '% ${l10n?.probability ?? 'Probability'}',
            style: TextStyle(
              fontSize: 12.8,
              color: isHighRisk
                  ? const Color(0xFFE11D48)
                  : styles.textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
