import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/cartesian_chart.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/green_text_chart_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';

class MelaveMeetingsChartPage extends StatelessWidget {
  const MelaveMeetingsChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      LinearProgressCard.dashboard(
        label: '',
        val: 9,
        total: 23,
        trailingButtonOnTap: () => Toaster.unimplemented(),
      ),
      GreenTextChartCard(
        topText: 'ממוצע זמן ביצוע מפגש עם חניכים',
        midText: '56 יום',
        botText: 'פירוט מפגשים שבוצעו',
        onTap: () => Toaster.unimplemented(),
      ),
      const ChartCardWrapper(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ממוצע זמן חודשי- יצירת מפגש עם החניכים',
                style: TextStyles.s14w400cGrey4,
              ),
              SizedBox(height: 12),
              CartesianChart(
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
      ),
    ];

    return ChartPageTemplate(
      title: 'מפגשים',
      children: children,
    );
  }
}
