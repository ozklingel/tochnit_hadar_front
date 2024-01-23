import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/controllers/melave_chart_controller.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/models/melave_chart.dto.dart';
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

class MelaveChartsDashboardScreen extends HookConsumerWidget {
  const MelaveChartsDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(melaveChartControllerProvider).valueOrNull ??
        const MelaveChartDto();

    final children = [
      const ChartHeader(),
      CircularProgressGauge(val: controller.melaveScore / 100),
      LinearProgressChartCard(
        title: 'שיחות',
        val: controller.oldVisitCalls,
        total: controller.apprenticesCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveCallsChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'מפגשים',
        val: controller.oldVisitMeeting,
        total: controller.apprenticesCount,
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
        val: controller.sadnaScore,
        total: controller.apprenticesCount,
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
        val: controller.kenesScore,
        total: controller.apprenticesCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveConferenceMeetingChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'שיחות היכרות הורים',
        val: controller.noVisitHorim,
        total: controller.apprenticesCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveCallParentsChartPage(),
          ),
        ),
      ),
      ChartDetailsCard.absolute(
        label: 'חניכים ‘נשכחים’',
        details: 'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
        val: controller.forgottenApprenticeCount,
        total: controller.apprenticesCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MelaveForgottenApprenticesChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'ביקורים בבסיס',
        val: controller.newVisitMeetingArmy,
        total: controller.apprenticesCount,
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
