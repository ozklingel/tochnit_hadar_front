import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/chart_card_wrapper.dart';
import 'package:hadar_program/src/views/secondary/charts/widgets/page_template.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/charts/cartesian_bars_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MelaveForgottenApprenticesChartPage extends ConsumerWidget {
  const MelaveForgottenApprenticesChartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];

    final children = [
      const ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'מספר חניכים שלא נוצר איתם קשר מעל 100 יום',
              style: TextStyles.s14w400cGrey4,
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '3',
                  style: TextStyles.s34w400cGreen,
                ),
                SizedBox(width: 8),
                Text(
                  'מתוך 16',
                  style: TextStyles.s12w400cGrey4,
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
      const ChartCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ממוצע פילוח חודשי של חניכים נשכחים',
              style: TextStyles.s14w400cGrey4,
            ),
            CartesianBarsChart(
              data: [
                (x: 'רבעון\nא', y: 4.1),
                (x: 'רבעון\nב', y: 2.5),
                (x: 'רבעון\nג', y: 0.5),
                (x: 'רבעון\nד', y: 7.8),
              ],
            ),
          ],
        ),
      ),
      const Text(
        'רשימת החניכים',
        style: TextStyles.s12w400cGrey4,
      ),
      ChartCardWrapper(
        child: apprentices.isEmpty
            ? Text('0 מתוך ${apprentices.length}')
            : ListView(
                shrinkWrap: true,
                children: apprentices
                    .take(3)
                    .map(
                      (e) => ListTileWithTagsCard(
                        avatar: e.avatar,
                        name: e.fullName,
                        onlineStatus: e.callStatus,
                        tags: e.tags,
                        onTap: () =>
                            PersonaDetailsRouteData(id: e.id).go(context),
                      ),
                    )
                    .toList(),
              ),
      ),
    ];

    return ChartPageTemplate(
      title: 'חניכים נשכחים',
      children: children,
    );
  }
}
