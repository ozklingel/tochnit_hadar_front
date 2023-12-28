import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';

class MelaveCallParentsChartPage extends StatelessWidget {
  const MelaveCallParentsChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const LinearProgressCard.page(
        label: 'שיחות הורים שנתיות שבוצעו',
        val: 8,
        total: 25,
        timestamp: '45 יום מתחילת התוכנית',
        subLabel: 'שיחות',
      ),
      ChartCardWrapper(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ביצוע שיחות שנתיות עם הורים לאורך השנים',
                style: TextStyles.s14w400cGrey4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <(int, double)>[
                    (2022, .85),
                    (2023, .92),
                    (2024, -1),
                    (2025, -1),
                  ]
                      .reversed
                      .map(
                        (e) => SizedBox(
                          height: 48,
                          child: Column(
                            children: [
                              if (!e.$2.isNegative)
                                Text(
                                  '${(e.$2 * 100).toInt().toString()}%',
                                  style: TextStyles.s24w400cGreen,
                                )
                              else
                                const Text(
                                  '_',
                                  style: TextStyles.s11w400,
                                ),
                              const Spacer(),
                              Text(
                                e.$1.toString(),
                                style: TextStyles.s11w400,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              TextButton(
                onPressed: () => Toaster.unimplemented(),
                child: const Text('לפירוט שיחות עם הורים'),
              ),
            ],
          ),
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'שיחות הורים',
      children: children,
    );
  }
}
