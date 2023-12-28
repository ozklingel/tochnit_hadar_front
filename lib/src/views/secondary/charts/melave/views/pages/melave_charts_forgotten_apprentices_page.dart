import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MelaveForgottenApprenticesChartPage extends ConsumerWidget {
  const MelaveForgottenApprenticesChartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    Logger().d(
      apprentices,
    );

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
                    width: 0.2,
                    dataLabelSettings: const DataLabelSettings(),
                    dataSource: const <({String x, double y})>[
                      (x: 'רבעון\nא', y: 4.1),
                      (x: 'רבעון\nב', y: 2.5),
                      (x: 'רבעון\nג', y: 0.5),
                      (x: 'רבעון\nד', y: 7.8),
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
      const Text(
        'רשימת החניכים',
        style: TextStyles.s12w400cGrey4,
      ),
      ChartCardWrapper(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: apprentices.isEmpty
              ? Text('0 מתוך ${apprentices.length}')
              : ListView(
                  shrinkWrap: true,
                  children: apprentices
                      .take(3)
                      .map(
                        (e) => ListTileWithTagsCard(
                          avatar: e.avatar,
                          name: e.fullName,
                          onlineStatus: e.onlineStatus,
                          tags: e.tags,
                        ),
                      )
                      .toList(),
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
