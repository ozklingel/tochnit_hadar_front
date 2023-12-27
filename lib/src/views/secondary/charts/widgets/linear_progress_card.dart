import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_container.dart';

class LinearProgressCard extends StatelessWidget {
  const LinearProgressCard.dashboard({
    super.key,
    required this.label,
    required this.val,
    required this.total,
    this.timestamp = '',
    this.onTap,
    this.trailingButtonOnTap,
    this.centerSubLabel = false,
  })  : isPrimary = true,
        subLabel = '';

  const LinearProgressCard.page({
    super.key,
    required this.label,
    required this.subLabel,
    required this.val,
    required this.total,
    this.timestamp = '',
    this.onTap,
    this.trailingButtonOnTap,
    this.centerSubLabel = false,
  }) : isPrimary = false;

  final String label;
  final String subLabel;
  final int val;
  final int total;
  final VoidCallback? onTap;
  final String timestamp;
  final VoidCallback? trailingButtonOnTap;
  final bool isPrimary;
  final bool centerSubLabel;

  @override
  Widget build(BuildContext context) {
    return ChartCardContainer(
      label: label,
      onTap: onTap,
      isPrimary: isPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                    TextSpan(
                      text: '$val/$total'
                          ' ',
                    ),
                    if (isPrimary) ...[
                      TextSpan(text: label),
                      const TextSpan(
                        text: ' '
                            'עם חניכים',
                      ),
                    ] else
                      TextSpan(text: subLabel),
                  ],
                ),
                style: TextStyles.s14w400cGrey2,
                textAlign: label.isEmpty && centerSubLabel
                    ? TextAlign.center
                    : TextAlign.end,
              ),
            ],
          ),
          if (trailingButtonOnTap != null) ...[
            const SizedBox(height: 6),
            TextButton(
              onPressed: trailingButtonOnTap,
              child: Text('פירוט $label שיש לבצע'),
            ),
          ],
        ],
      ),
    );
  }
}
