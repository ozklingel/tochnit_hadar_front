import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

@Deprecated('not needed now since this will be done by backend')
class InstitutionPdfExport extends StatelessWidget {
  const InstitutionPdfExport({
    super.key,
    required this.institution,
    required this.startDate,
    required this.endDate,
  });

  final InstitutionDto institution;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: AppColors.blue08,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.name,
                      style: TextStyles.s20w500,
                    ),
                    Text(
                      'תאריכים: '
                      '${startDate.asDayMonthYearShortDot}'
                      ' - '
                      '${endDate.asDayMonthYearShortDot}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                    Text(
                      'שם רכז: '
                      '${institution.rakazFirstName + institution.rakazLastName}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                    Text(
                      'כמות חניכים: '
                      '${institution.apprentices.length}',
                      style: TextStyles.s12w400cGrey2,
                    ),
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: e,
                        ),
                      )
                      .toList(),
                ),
                const Spacer(),
                if (institution.logo.isNotEmpty) ...[
                  const SizedBox(width: 20),
                  CachedNetworkImage(
                    imageUrl: institution.logo,
                    height: 40,
                    progressIndicatorBuilder: (context, url, progress) =>
                        const LoadingState(),
                  ),
                ],
                Assets.images.logo.image(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'כללי',
                    style: TextStyles.s16w500,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: AppColors.shades200,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SfCircularChart(
                            backgroundColor: Colors.transparent,
                            title: const ChartTitle(
                              text: 'title',
                              alignment: ChartAlignment.center,
                              textStyle: TextStyles.s11w500,
                            ),
                            legend: Legend(
                              isVisible: true,
                              itemPadding: 0,
                              alignment: ChartAlignment.center,
                              position: LegendPosition.left,
                              overflowMode: LegendItemOverflowMode.wrap,
                              legendItemBuilder: (
                                legendText,
                                series,
                                point,
                                seriesIndex,
                              ) =>
                                  Padding(
                                padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ) +
                                    const EdgeInsets.only(right: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 6,
                                      backgroundColor: seriesIndex == 0
                                          ? AppColors.chartRed
                                          : seriesIndex == 1
                                              ? AppColors.chartOrange
                                              : AppColors.chartGreen,
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
                                dataSource: const [],
                                xValueMapper: (datum, _) =>
                                    '${datum.x}:${datum.y.toInt()}',
                                yValueMapper: (datum, _) => datum.y,
                                legendIconType: LegendIconType.circle,
                                pointColorMapper: (datum, index) => index == 0
                                    ? AppColors.chartRed
                                    : index == 1
                                        ? AppColors.chartOrange
                                        : AppColors.chartGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'תפקוד מלווים',
                    style: TextStyles.s16w500,
                  ),
                  Wrap(
                    children: [
                      Column(
                        children: [
                          const Text('ממוצע שיחות'),
                          Row(
                            children: [
                              const Text(
                                '24',
                                style: TextStyles.s16w700,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'יום',
                                style: TextStyles.s11w400,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                FluentIcons.data_trending_24_regular,
                                size: 20,
                                color: AppColors.green1,
                              ),
                              Assets.icons.dataTrendingDown.svg(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
