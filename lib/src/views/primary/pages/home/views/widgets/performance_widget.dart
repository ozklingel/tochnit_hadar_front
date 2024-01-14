import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/expansion_tile_container.dart';
import 'package:hadar_program/src/views/widgets/charts/cartesian_line_chart.dart';

class PerformanceWidget extends StatelessWidget {
  const PerformanceWidget({
    super.key,
    required this.title,
    required this.data,
    required this.onTap,
  });

  final String title;
  final List<(double, double)> data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileContainer(
      title: title,
      height: 300,
      children: [
        CartesianLineChart(
          onTap: onTap,
          xAxisTitle: 'ציון',
          yAxisTitle: 'כמות מלווים',
          interval: 20,
          max: 100,
          data: data,
        ),
      ],
    );
  }
}
