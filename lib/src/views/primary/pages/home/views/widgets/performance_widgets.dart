import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/performance_status_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/expansion_tile_container.dart';
import 'package:hadar_program/src/views/widgets/charts/cartesian_line_chart.dart';

class MelavimPerformanceWidget extends StatelessWidget {
  const MelavimPerformanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileContainer(
      title: 'תפקוד מלווים',
      height: 300,
      children: [
        CartesianLineChart(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד מלווים',
              ),
            ),
          ),
          xAxisTitle: 'ציון',
          yAxisTitle: 'כמות מלווים',
          interval: 20,
          max: 100,
          data: const [
            (0, 20),
            (20, 40),
            (40, 74),
            (60, 20),
            (80, 10),
            (100, 50),
          ],
        ),
      ],
    );
  }
}

class RakazimPerformanceWidget extends StatelessWidget {
  const RakazimPerformanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileContainer(
      title: 'תפקוד רכזים',
      height: 300,
      children: [
        CartesianLineChart(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד רכזים',
              ),
            ),
          ),
          xAxisTitle: 'ציון',
          yAxisTitle: 'כמות מלווים',
          interval: 20,
          max: 100,
          data: const [
            (0, 20),
            (20, 40),
            (40, 74),
            (60, 20),
            (80, 10),
            (100, 50),
          ],
        ),
      ],
    );
  }
}

class RakazeiEshkolPerformanceWidget extends StatelessWidget {
  const RakazeiEshkolPerformanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileContainer(
      title: 'תפקוד רכזי אשכול',
      height: 300,
      children: [
        CartesianLineChart(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PerformanceStatusScreen(
                title: 'תפקוד רכזים',
              ),
            ),
          ),
          xAxisTitle: 'ציון',
          yAxisTitle: 'כמות מלווים',
          interval: 20,
          max: 100,
          data: const [
            (0, 20),
            (20, 40),
            (40, 74),
            (60, 20),
            (80, 10),
            (100, 50),
          ],
        ),
      ],
    );
  }
}
