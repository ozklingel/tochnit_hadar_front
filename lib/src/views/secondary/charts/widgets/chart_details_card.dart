import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_container.dart';

class ChartDetailsCard extends StatelessWidget {
  const ChartDetailsCard.percentage({
    super.key,
    required this.label,
    required this.val,
    required this.total,
    this.suffixText = '',
    this.details = '',
    this.timestamp = '',
    this.onTap,
  }) : isPercentage = true;

  const ChartDetailsCard.absolute({
    super.key,
    required this.label,
    required this.val,
    required this.total,
    this.details = '',
    this.timestamp = '',
    this.suffixText = '',
    this.onTap,
  }) : isPercentage = false;

  final String label;
  final String details;
  final String suffixText;
  final String timestamp;
  final int val;
  final int total;
  final VoidCallback? onTap;
  final bool isPercentage;

  @override
  Widget build(BuildContext context) {
    return ChartCardContainer(
      label: label,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (details.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              details,
              style: TextStyles.s12w400cGrey4,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isPercentage
                    ? '${(val / (total == 0 ? 1 : total) * 100).toInt()}%'
                    : val.toInt().toString(),
                style: TextStyles.s34w400cGreen,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                  right: 8,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (isPercentage)
                        TextSpan(
                          text: '$val'
                              ' ',
                        ),
                      if (suffixText.isNotEmpty)
                        const TextSpan(
                          text: 'מפגשים',
                        )
                      else
                        TextSpan(
                          text: 'מתוך'
                              ' '
                              '$total',
                        ),
                      if (isPercentage && suffixText.isEmpty)
                        const TextSpan(
                          text: ' '
                              'מפגשים מלווים מקצועי',
                        ),
                    ],
                  ),
                  style: TextStyles.s14w400cGrey2,
                ),
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}
