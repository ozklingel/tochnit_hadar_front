import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MelaveForgottenApprenticesChartPage extends StatelessWidget {
  const MelaveForgottenApprenticesChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const ChartCardWrapper(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
                style: TextStyles.s14w400cGrey4,
              ),
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '3',
                      style: TextStyles.s34w400cGreen,
                    ),
                    TextSpan(text: '    '),
                    TextSpan(
                      text: 'מתוך 16',
                      style: TextStyles.s12w400cGrey4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
      ChartCardWrapper(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ממוצע פילוח חודשי של חניכים נשכחים',
                style: TextStyles.s14w400cGrey4,
              ),
              SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: const CategoryAxis(
                  labelStyle: TextStyle(color: Colors.white),
                  axisLine: AxisLine(width: 0),
                  labelPosition: ChartDataLabelPosition.inside,
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: const NumericAxis(
                  isVisible: false,
                ),
                series: [
                  ColumnSeries<({String x, int y}), String>(
                    width: 0.2,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    ),
                    dataSource: const <({String x, int y})>[
                      (x: 'New York', y: 8683),
                      (x: 'Tokyo', y: 6993),
                      (x: 'Chicago', y: 5498),
                      (x: 'Atlanta', y: 5083),
                      (x: 'Boston', y: 4497),
                    ],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    xValueMapper: (sales, _) => sales.x,
                    yValueMapper: (sales, _) => sales.y,
                    color: AppColors.blue03,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'חניכים נשכחים',
      children: children,
    );
  }
}
