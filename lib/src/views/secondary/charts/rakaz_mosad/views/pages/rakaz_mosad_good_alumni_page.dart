import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:hadar_program/src/views/widgets/cards/report_card.dart';

class RakazMosadGoodAlumniChartPage extends StatelessWidget {
  const RakazMosadGoodAlumniChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      LinearProgressChartCard(
        val: 2,
        total: 3,
        subLabelSuffix: 'שיחות לחניכים',
        trailingButtonOnTap: () => Toaster.unimplemented(),
        trailingButtonText: 'פירוט שיחות שיש לבצע',
      ),
      const Text(
        'פירוט',
        style: TextStyles.s16w400cGrey4,
      ),
      ListView(
        shrinkWrap: true,
        children: List.generate(
          3,
          (index) => ReportCard(
            report: ReportDto(
              dateTime: DateTime.now()
                  .subtract(Duration(minutes: 21 * (index + 1)))
                  .toIso8601String(),
            ),
          ),
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'עשיה לטובת בוגרים',
      children: children,
    );
  }
}
