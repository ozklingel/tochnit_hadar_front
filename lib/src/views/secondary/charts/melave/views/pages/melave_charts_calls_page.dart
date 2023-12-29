import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/green_text_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:hadar_program/src/views/widgets/charts/cartesian_line_chart.dart';

class MelaveCallsChartPage extends StatelessWidget {
  const MelaveCallsChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      LinearProgressChartCard(
        title: '',
        val: 12,
        total: 34,
        trailingButtonOnTap: () => Toaster.unimplemented(),
      ),
      GreenTextChartCard(
        topText: 'ממוצע זמן ביצוע שיחה לחניכים',
        midText: '68 יום',
        botText: 'פירוט שיחות שבוצעו',
        onTap: () => Toaster.unimplemented(),
      ),
      const ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ממוצע זמן חודשי- יצירת שיחה עם החניכים',
              style: TextStyles.s14w400cGrey4,
            ),
            SizedBox(height: 12),
            CartesianLineChart(
              xAxisTitle: 'חודשים',
              yAxisTitle: 'ממוצע ימים',
              interval: 1,
              max: 12,
              data: [
                (1, 20),
                (2, 40),
                (3, 74),
                (4, 20),
                (5, 10),
                (6, 50),
              ],
            ),
          ],
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'שיחות',
      children: children,
    );
  }
}
