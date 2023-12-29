import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';

class GreenTextChartCard extends StatelessWidget {
  const GreenTextChartCard({
    super.key,
    required this.topText,
    required this.midText,
    required this.botText,
    this.onTap,
  });

  final String topText;
  final String midText;
  final String botText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChartCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            topText,
            style: TextStyles.s14w400cGrey4,
          ),
          const SizedBox(height: 12),
          Text(
            midText,
            style: TextStyles.s34w400cGreen,
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              child: Text(botText),
            ),
        ],
      ),
    );
  }
}
