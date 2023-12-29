import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianBarsChart extends StatelessWidget {
  const CartesianBarsChart({
    super.key,
    required this.data,
  });

  final List<({String x, double y})> data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        opposedPosition: true,
        majorTickLines: MajorTickLines(width: 0),
        minorTickLines: MinorTickLines(width: 0),
        minorGridLines: MinorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        interval: 2,
      ),
      series: [
        ColumnSeries<({String x, double y}), String>(
          width: 0.14,
          dataLabelSettings: const DataLabelSettings(),
          dataSource: data,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          xValueMapper: (x, _) => x.x,
          yValueMapper: (x, _) => x.y,
          color: AppColors.blue03,
        ),
      ],
    );
  }
}
