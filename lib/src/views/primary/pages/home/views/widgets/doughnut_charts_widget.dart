// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/expansion_tile_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChartsWidget extends StatelessWidget {
  const DoughnutChartsWidget({
    super.key,
    required this.callsRed,
    required this.callsGreen,
    required this.callsOrange,
    required this.meeetingsRed,
    required this.meeetingsOrange,
    required this.meeetingsGreen,
  });

  final double meeetingsRed;
  final double meeetingsOrange;
  final double meeetingsGreen;
  final double callsRed;
  final double callsOrange;
  final double callsGreen;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileContainer(
      title: 'סטטוס חניכים',
      height: 180,
      children: [
        _DoughnutChart(
          onTap: () => const PerformanceStatusRouteData(
            initIndex: 2,
            isExtended: false,
            title: 'סטטוס חניכים',
            subtitle: 'חניכים שלא נוצר איתם קשר מעל 100 יום',
          ).push(context),
          title: 'מפגשים',
          data: [
            (x: 'לא תקין', y: meeetingsRed),
            (x: 'תקין חלקית', y: meeetingsOrange),
            (x: 'תקין', y: meeetingsGreen),
          ],
        ),
        _DoughnutChart(
          onTap: () => const PerformanceStatusRouteData(
            initIndex: 1,
            isExtended: false,
            title: 'סטטוס חניכים',
            subtitle: 'חניכים שלא נוצר איתם קשר מעל 100 יום',
          ).push(context),
          title: 'שיחות',
          data: [
            (x: 'לא תקין', y: callsRed),
            (x: 'תקין חלקית', y: callsOrange),
            (x: 'תקין', y: callsGreen),
          ],
        ),
      ],
    );
  }
}

class _DoughnutChart extends StatelessWidget {
  const _DoughnutChart({
    super.key,
    required this.title,
    required this.data,
    required this.onTap,
  });

  final String title;
  final List<({String x, double y})> data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 280,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SfCircularChart(
                backgroundColor: Colors.transparent,
                title: ChartTitle(
                  text: title,
                  alignment: ChartAlignment.far,
                  textStyle: TextStyles.s16w400cGrey1,
                ),
                legend: Legend(
                  isVisible: true,
                  itemPadding: 0,
                  alignment: ChartAlignment.center,
                  position: LegendPosition.left,
                  overflowMode: LegendItemOverflowMode.wrap,
                  legendItemBuilder: (legendText, series, point, seriesIndex) =>
                      Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6) +
                        const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: seriesIndex == 0
                              ? AppColors.blue02
                              : seriesIndex == 1
                                  ? AppColors.blue04
                                  : AppColors.blue06,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          legendText.split(':').first,
                          style: TextStyles.s12w400cGrey2,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          legendText.split(':').last,
                          style: TextStyles.s12w400cGrey4,
                        ),
                      ],
                    ),
                  ),
                ),
                series: [
                  DoughnutSeries<({String x, double y}), String>(
                    explode: true,
                    radius: '100%',
                    innerRadius: '70%',
                    dataSource: data,
                    xValueMapper: (datum, _) => '${datum.x}:${datum.y.toInt()}',
                    yValueMapper: (datum, _) => datum.y,
                    legendIconType: LegendIconType.circle,
                    pointColorMapper: (datum, index) => index == 0
                        ? AppColors.blue02
                        : index == 1
                            ? AppColors.blue04
                            : AppColors.blue06,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
