import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianLineChart extends StatelessWidget {
  const CartesianLineChart({
    super.key,
    required this.data,
    required this.xAxisTitle,
    required this.yAxisTitle,
    required this.max,
    required this.interval,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  final List<(double, double)> data;
  final String xAxisTitle;
  final String yAxisTitle;
  final double max;
  final double interval;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: padding,
        child: IgnorePointer(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            borderWidth: 0,
            primaryXAxis: NumericAxis(
              title: AxisTitle(
                text: xAxisTitle,
                textStyle: TextStyles.s12w400cGrey3,
              ),
              majorGridLines: const MajorGridLines(width: 0),
              minorGridLines: const MinorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
              axisLine: const AxisLine(width: 0),
              borderColor: Colors.transparent,
              interval: interval,
              borderWidth: 0,
              maximum: max,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: yAxisTitle,
                textStyle: TextStyles.s12w400cGrey3,
              ),
              majorGridLines: const MajorGridLines(width: 0),
              minorGridLines: const MinorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
              axisLine: const AxisLine(width: 0),
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
        ),
      ),
    );
  }
}
