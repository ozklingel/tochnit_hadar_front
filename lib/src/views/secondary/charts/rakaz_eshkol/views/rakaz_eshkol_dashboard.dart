import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/controllers/rakaz_eshkol_chart_controller.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/models/rakaz_eshkol_chart.dto.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/views/pages/rakaz_eshkol_forgotten_apprentices_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/views/pages/rakaz_eshkol_monthly_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_details_card.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_header.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/charts_appbar.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/circular_progress_gauge.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RakazEshkolChartsDashboardScreen extends HookConsumerWidget {
  const RakazEshkolChartsDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        ref.watch(rakazEshkolChartControllerProvider).valueOrNull ??
            const RakazEshkolChartDto();

    final children = [
      const ChartHeader(),
      CircularProgressGauge(val: controller.eshkolCoordinatorScore / 100),
      LinearProgressChartCard(
        title: 'ישיבה חודשית עם רכז',
        subLabelSuffix: 'ישיבות',
        val: controller.goodMosadRacazMeeting,
        total: controller.allMosadCoordinatorCount,
        timestamp: 'אוקטובר',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RakazEshkolMonthlyMeetingChartPage(),
          ),
        ),
      ),
      ChartDetailsCard.percentage(
        label: 'מפגש חודשי עם ראש התוכנית',
        suffixText: 'מפגשים',
        val: controller.newVisitYeshivaTohnit,
        total: controller.allMosadCoordinatorCount,
      ),
      ChartDetailsCard.absolute(
        label: 'חניכים ‘נשכחים’',
        details: 'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
        val: controller.apprenticeForgottenCount,
        total: controller.allEshcolApprenticesCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                const RakazEshkolForgottenApprenticesChartPage(),
          ),
        ),
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
