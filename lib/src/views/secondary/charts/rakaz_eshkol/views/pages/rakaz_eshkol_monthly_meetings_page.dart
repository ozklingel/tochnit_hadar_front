import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/green_text_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:hadar_program/src/views/widgets/charts/cartesian_line_chart.dart';

class RakazEshkolMonthlyMeetingChartPage extends StatelessWidget {
  const RakazEshkolMonthlyMeetingChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const LinearProgressChartCard(
        title: '',
        subLabelSuffix: 'ישיבות',
        val: 2,
        total: 10,
      ),
      const GreenTextChartCard(
        topText: 'ממוצע מרווח ישיבות חודשיות',
        midText: '68 יום',
        botText: 'פירוט שיחות שבוצעו',
      ),
      const ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ממוצע זמן חודשי- ישיבות חודשיות עם רכזים',
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
      title: 'שיחות הורים',
      children: children,
    );
  }
}
