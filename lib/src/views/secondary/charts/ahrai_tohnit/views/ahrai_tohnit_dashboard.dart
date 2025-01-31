import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_call_parents_page.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_calls_page.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_conference_page.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_forgotten_apprentices_page.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_professional_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_details_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_header.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/charts_appbar.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/circular_progress_gauge.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AhraiTohnitChartsDashboardScreen extends HookConsumerWidget {
  const AhraiTohnitChartsDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final children = [
      const ChartHeader(),
      const CircularProgressGauge(val: .4),
      LinearProgressChartCard(
        title: 'שיחות',
        val: 5,
        total: 20,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveCallsChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'מפגשים',
        val: 8,
        total: 16,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveMeetingsChartPage(),
          ),
        ),
      ),
      ChartDetailsCard.percentage(
        label: 'מפגש מלווים מקצועי',
        details: 'מפגשים שבוצעו ברבעון הנוכחי',
        timestamp: '2 רבעונים',
        val: 2,
        total: 2,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveProfessionalMeetingChartPage(),
          ),
        ),
      ),
      ChartDetailsCard.percentage(
        label: 'כנס מלווים שנתי',
        details: 'מפגשים שבוצעו ברבעון הנוכחי',
        timestamp: '2 שנים',
        val: 1,
        total: 2,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveConferenceMeetingChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'שיחות היכרות הורים',
        val: 15,
        total: 18,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveCallParentsChartPage(),
          ),
        ),
      ),
      ChartDetailsCard.absolute(
        label: 'חניכים ‘נשכחים’',
        details: 'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
        val: 2,
        total: 43,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveForgottenApprenticesChartPage(),
          ),
        ),
      ),
      const LinearProgressChartCard(
        title: 'ביקורים בבסיס',
        val: 60,
        total: 100,
        timestamp: 'עברו 2 רבעונים',
      ),
    ];

    return Scaffold(
      appBar: const ChartsAppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
