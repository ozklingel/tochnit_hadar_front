import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_container.dart';

class LinearProgressChartCard extends StatelessWidget {
  const LinearProgressChartCard({
    super.key,
    required this.val,
    required this.total,
    this.subLabelSuffix = '',
    this.title = '',
    this.subtitle = '',
    this.subLabelPrefix = '',
    this.timestamp = '',
    this.onTap,
    this.trailingButtonOnTap,
    this.centerSubLabel = false,
    this.wrapInCardContainer = true,
    this.isPrimary = false,
    this.trailingButtonText = '',
  });

  final String title;
  final String subtitle;
  final String subLabelPrefix;
  final String subLabelSuffix;
  final int val;
  final int total;
  final String timestamp;
  final bool isPrimary;
  final bool centerSubLabel;
  final bool wrapInCardContainer;
  final VoidCallback? onTap;
  final VoidCallback? trailingButtonOnTap;
  final String trailingButtonText;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (subtitle.isNotEmpty) ...[
          Text(
            subtitle,
            style: TextStyles.s12w400cGrey4,
          ),
        ],
        const SizedBox(height: 12),
        if (total != 0)
          LinearProgressIndicator(
            value: val / total,
            backgroundColor: AppColors.blue06,
            color: AppColors.blue03,
            minHeight: 8,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (timestamp.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    FluentIcons.clock_24_regular,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timestamp,
                    style: TextStyles.s12w400cGrey4,
                  ),
                ],
              ),
            ],
            if (!centerSubLabel) const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: subLabelPrefix),
                  TextSpan(
                    text: '$val/$total'
                        ' ',
                  ),
                  TextSpan(text: subLabelSuffix),
                ],
              ),
              style: TextStyles.s14w400cGrey2,
              textAlign: title.isEmpty && centerSubLabel
                  ? TextAlign.center
                  : TextAlign.end,
            ),
          ],
        ),
        if (trailingButtonOnTap != null && trailingButtonText.isNotEmpty) ...[
          const SizedBox(height: 6),
          TextButton(
            onPressed: trailingButtonOnTap,
            child: Text(trailingButtonText),
          ),
        ],
      ],
    );

    if (wrapInCardContainer) {
      return ChartCardContainer(
        label: title,
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}
