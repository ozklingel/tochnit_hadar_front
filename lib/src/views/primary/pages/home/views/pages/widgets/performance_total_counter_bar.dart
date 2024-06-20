import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class PerformanceTotalCounterBar extends StatelessWidget {
  const PerformanceTotalCounterBar({
    super.key,
    required this.label,
    required this.total,
    this.percent = 0,
  });

  final String label;
  final int total;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.s16w500cGrey2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'סה"כ'
                ' '
                '$total',
                style: TextStyles.s14w300cGray5,
              ),
              if (percent != 0) ...[
                const SizedBox(width: 8),
                if (percent > 0)
                  const Icon(
                    FluentIcons.arrow_trending_24_regular,
                    color: AppColors.green1,
                    size: 16,
                  )
                else
                  const Icon(
                    FluentIcons.arrow_trending_down_24_regular,
                    color: AppColors.red1,
                    size: 16,
                  ),
                Text(
                  '$percent%',
                  style: TextStyles.s12w300cGray5,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
