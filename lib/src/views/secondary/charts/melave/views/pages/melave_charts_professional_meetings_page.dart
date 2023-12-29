import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_details_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MelaveProfessionalMeetingChartPage extends StatelessWidget {
  const MelaveProfessionalMeetingChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const ChartDetailsCard.percentage(
        label: '',
        details: 'מפגשים שבוצעו ברבעון הנוכחי',
        timestamp: '2 רבעונים',
        val: 2,
        total: 2,
      ),
      const LinearProgressChartCard(
        title: 'מפגשים שבוצעו מתחילת השנה',
        val: 2,
        total: 4,
        timestamp: '2 רבעונים',
        subLabelSuffix: 'מפגשים',
      ),
      ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'השתתפות במפגשים מלווים מקצועי - לפי רבעון',
              style: TextStyles.s14w400cGrey4,
            ),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(width: 0),
                axisLine: AxisLine(width: 0),
              ),
              primaryYAxis: const NumericAxis(
                axisLine: AxisLine(width: 0),
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(size: 0),
              ),
              series: [
                ColumnSeries<({String x, double y}), String>(
                  width: 0.26,
                  dataSource: const <({String x, double y})>[
                    (x: 'רבעון א', y: 71),
                    (x: 'רבעון ב', y: 84),
                    (x: 'רבעון ג', y: 48),
                    (x: 'רבעון ד', y: 48),
                  ],
                  isTrackVisible: true,
                  trackColor: const Color.fromRGBO(198, 201, 207, 1),
                  borderRadius: BorderRadius.circular(36),
                  xValueMapper: (({String x, double y}) sales, _) => sales.x,
                  yValueMapper: (({String x, double y}) sales, _) => sales.y,
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'מפגש מלווים מקצועי',
      children: children,
    );
  }
}
