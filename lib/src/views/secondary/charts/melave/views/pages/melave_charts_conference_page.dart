import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';

class MelaveConferenceMeetingChartPage extends StatelessWidget {
  const MelaveConferenceMeetingChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const ChartCardWrapper(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'עוד לא התקיים כנס בשנה זו',
            style: TextStyles.s12w400cGrey4,
          ),
        ),
      ),
      const LinearProgressCard.page(
        label: 'השתתפות בכנסים במהלך כל השנים',
        val: 2,
        total: 4,
        timestamp: '2 רבעונים',
        subLabel: 'מפגשים',
        centerSubLabel: true,
      ),
      ChartCardWrapper(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'השתתפות במפגשים מלווים מקצועי - לפי רבעון',
                style: TextStyles.s14w400cGrey4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <(int, bool)>[
                    (2022, true),
                    (2023, true),
                    (2024, false),
                    (2025, false),
                  ]
                      .reversed
                      .map(
                        (e) => SizedBox(
                          height: 48,
                          child: Column(
                            children: [
                              if (e.$2)
                                const Text(
                                  'V',
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
            ],
          ),
        ),
      ),
    ];

    return ChartPageTemplate(
      title: 'כנס מלווים שנתי',
      children: children,
    );
  }
}
