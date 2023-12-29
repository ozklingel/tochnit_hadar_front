import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/cartesian_monthly_chart.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/green_text_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';

class RakazMosadProfessionalMeetingsChartPage extends StatelessWidget {
  const RakazMosadProfessionalMeetingsChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      LinearProgressChartCard(
        val: 12,
        total: 34,
        subLabelSuffix: 'שיחות לחניכים',
        trailingButtonOnTap: () => Toaster.unimplemented(),
        trailingButtonText: 'פירוט שיחות שיש לבצע',
      ),
      GreenTextChartCard(
        topText: 'ממוצע מרווח בחן המפגשים המקצועיים',
        midText: '68 יום',
        botText: 'פירוט שיחות שבוצעו',
        onTap: () => Toaster.unimplemented(),
      ),
      const ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ממוצע זמן חודשי- יצירת שיחה עם החניכים',
              style: TextStyles.s14w400cGrey4,
            ),
            SizedBox(height: 12),
            CartesianMonthlyChart(
              data: [
                (1, 20),
                (2, 40),
                (3, 74),
                (4, 20),
                (5, 10),
                (6, 50),
              ],
            ),
          ],
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'מפגשים מקצועיים למלווים',
      children: children,
    );
  }
}
