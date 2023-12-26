import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_container.dart';

class LinearProgressCard extends StatelessWidget {
  const LinearProgressCard({
    super.key,
    required this.label,
    required this.val,
    required this.total,
    this.timestamp = '',
    this.onTap,
  });

  final String label;
  final int val;
  final int total;
  final VoidCallback? onTap;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return ChartCardContainer(
      label: label,
      onTap: onTap,
      child: Column(
        children: [
          LinearProgressIndicator(
            value: val / total,
            backgroundColor: AppColors.blue06,
            color: AppColors.blue03,
            minHeight: 8,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 12),
          Text(
            '$val/$total'
            ' '
            '$label'
            ' '
            'עם חניכים',
            style: TextStyles.s14w400cGrey2,
            textAlign: TextAlign.end,
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
