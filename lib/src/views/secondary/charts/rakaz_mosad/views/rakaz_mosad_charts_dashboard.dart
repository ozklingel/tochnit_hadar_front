import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/views/pages/melave_charts_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/controllers/rakaz_mosad_chart_controller.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/models/rakaz_mosad_chart.dto.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/pages/rakaz_mosad_forgotten_apprentices_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/pages/rakaz_mosad_good_alumni_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/pages/rakaz_mosad_interactions_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/pages/rakaz_mosad_matsber_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/views/pages/rakaz_mosad_professional_meetings_page.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_container.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_header.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/charts_appbar.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/circular_progress_gauge.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/linear_progress_chart_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RakazMosadChartsDashboardScreen extends HookConsumerWidget {
  const RakazMosadChartsDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        ref.watch(rakazMosadChartControllerProvider).valueOrNull ??
            const RakazMosadChartDto();

    var children = [
      const ChartHeader(),
      CircularProgressGauge(val: controller.mosadCoordinatorScore / 100),
      LinearProgressChartCard(
        title: 'מפגשים מקצועיים למלווים',
        subLabelSuffix: 'מפגשים שבוצעו',
        val: controller.goodMelaveIdsSadna,
        total: controller.allMelaveMosadCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                const RakazMosadProfessionalMeetingsChartPage(),
          ),
        ),
      ),
      LinearProgressChartCard(
        title: 'ישיבות מצב”ר',
        subLabelSuffix: 'ישיבות שבוצעו',
        val: controller.goodMelaveIdsMatzbar,
        total: controller.allMelaveMosadCount,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RakazMosadMatsberMeetingsChartPage(),
          ),
        ),
      ),
      ChartCardContainer(
        label: 'אינטרקציות מלווים מול חניכים',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RakazMosadInteractionsChartPage(),
          ),
        ),
        child: Column(
          children: [
            LinearProgressChartCard(
              subtitle: 'מפגשים',
              subLabelSuffix: 'מפגשים שבוצעו',
              val: controller.goodApprenticeMosadMeet,
              total: controller.allApprentiesMosadCount,
              wrapInCardContainer: false,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MelaveMeetingsChartPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressChartCard(
              subtitle: 'שיחות',
              subLabelSuffix: 'שיחות שבוצעו',
              val: controller.goodApprenticeMosadCall,
              total: controller.allApprentiesMosadCount,
              wrapInCardContainer: false,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MelaveMeetingsChartPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressChartCard(
              subtitle: 'מפגשים פיזיים קבוצתיים',
              subLabelSuffix: 'מפגשים פיזיים שבוצעו',
              val: controller.goodApprenticeMosadGroupMeet,
              total: controller.allApprentiesMosadCount,
              wrapInCardContainer: false,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MelaveMeetingsChartPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      ChartCardContainer(
        label: 'הכנסת מחזור חדש למערכת',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                'הכנסת מחזור ${DateTime.now().year}',
                style: TextStyles.s12w400cGrey4,
              ),
              const Spacer(),
              controller.isVisitedMahzor
                  ? const Text(
                      'בוצע',
                      style: TextStyles.s24w400cGreen,
                    )
                  : const Text(
                      'לא בוצע',
                      style: TextStyles.s24w400cRed,
                    ),
            ],
          ),
        ),
      ),
      LinearProgressChartCard(
        val: controller.visitDoForBogrim,
        total: controller.allApprentiesMosadCount,
        title: 'עשיה לטובת בוגרים',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RakazMosadGoodAlumniChartPage(),
          ),
        ),
        subLabelSuffix: 'עשיה לטובת בוגרים',
      ),
      LinearProgressChartCard(
        val: controller.newMelaveMeeting,
        total: controller.allApprentiesMosadCount,
        title: 'ביצוע מפגשים עם המלווים',
        subLabelSuffix: 'מפגשים',
        timestamp: 'רבעון שני',
      ),
      LinearProgressChartCard(
        val: controller.avgPresenceMelavimMeeting,
        total: controller.allApprentiesMosadCount,
        title: 'נוכחות בישיבה חודשית',
        subLabelSuffix: 'ישיבות',
        timestamp: 'עברו 3 רבעונים',
      ),
      ChartCardContainer(
        label: 'חניכים ‘נשכחים’',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                const RakazMosadForgottenApprenticesChartPage(),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
              style: TextStyles.s12w400cGrey4,
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: controller.apprenticeForgottenCount.toString(),
                    style: TextStyles.s34w400cGreen,
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: 'מתוך ${controller.allApprentiesMosadCount}',
                    style: TextStyles.s14w400cGrey2,
                  ),
                ],
              ),
            ),
          ],
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
