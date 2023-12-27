import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/green_text_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MelaveCallsChartPage extends StatelessWidget {
  const MelaveCallsChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      LinearProgressCard.dashboard(
        label: '',
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
      ChartCardWrapper(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ממוצע זמן חודשי- יצירת שיחה עם החניכים',
                style: TextStyles.s14w400cGrey4,
              ),
              const SizedBox(height: 12),
              IgnorePointer(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  borderWidth: 0,
                  primaryXAxis: const NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    minorGridLines: MinorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(width: 0),
                    borderColor: Colors.transparent,
                    interval: 1,
                    borderWidth: 0,
                  ),
                  primaryYAxis: const NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    minorGridLines: MinorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(width: 0),
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                  ),
                  borderColor: Colors.transparent,
                  plotAreaBorderColor: Colors.transparent,
                  plotAreaBackgroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  legend: const Legend(
                    title: LegendTitle(
                      text: 'ממוצע ימים',
                    ),
                    borderColor: Colors.transparent,
                  ),
                  series: [
                    SplineSeries<(double, double), num>(
                      splineType: SplineType.cardinal,
                      dataSource: const [
                        (1, 20),
                        (2, 40),
                        (3, 74),
                        (4, 20),
                        (5, 10),
                        (6, 50),
                      ],
                      xValueMapper: ((double, double) sales, _) => sales.$1,
                      yValueMapper: ((double, double) sales, _) => sales.$2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'שיחות',
      children: children,
    );
  }
}
