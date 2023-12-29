import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianMonthlyChart extends StatelessWidget {
  const CartesianMonthlyChart({
    super.key,
    required this.data,
  });

  final List<(double, double)> data;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        borderWidth: 0,
        primaryXAxis: const NumericAxis(
          title: AxisTitle(
            text: 'חודשים',
            textStyle: TextStyles.s12w400cGrey3,
          ),
          majorGridLines: MajorGridLines(width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
          borderColor: Colors.transparent,
          interval: 1,
          borderWidth: 0,
          maximum: 12,
        ),
        primaryYAxis: const NumericAxis(
          title: AxisTitle(
            text: 'ממוצע ימים',
            textStyle: TextStyles.s12w400cGrey3,
          ),
          majorGridLines: MajorGridLines(width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
        borderColor: Colors.transparent,
        plotAreaBorderColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        series: [
          SplineSeries<(double, double), num>(
            splineType: SplineType.cardinal,
            dataSource: data,
            xValueMapper: ((double, double) x, _) => x.$1,
            yValueMapper: ((double, double) y, _) => y.$2,
          ),
        ],
      ),
    );
  }
}
