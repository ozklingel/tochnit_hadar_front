import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/api/madadim/get_personas_scores.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/personas_scores.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/percentage_list_tile_with_tags_widget.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/performance_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RakazimPerformanceScreen extends HookConsumerWidget {
  const RakazimPerformanceScreen({
    super.key,
    required this.title,
    required this.type,
  });

  final UserRole type;
  final String title;

  @override
  Widget build(BuildContext context, ref) {
    final scores = ref.watch(getPersonasScoresProvider).valueOrNull ??
        const PersonasScoresDto();
    final personas = ref.watch(getPersonasProvider).valueOrNull ?? [];
    final filteredEshkol = personas.where(
      (element) => scores.rakazEshkolList.any(
        (e) => e.id == element.id,
      ),
    );
    final filteredMosad = personas.where(
      (element) => scores.rakazEshkolList.any(
        (e) => e.id == element.id,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          title,
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            // TODO(noga)
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const ExportToExcelBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: Consts.defaultDurationXL,
              child: PerformanceBody(
                children: type.isRakazMosad
                    ? filteredMosad
                        .map(
                          (e) => const PercentageListTileWithTagsWidget(),
                        )
                        .toList()
                    : filteredEshkol
                        .map(
                          (e) => const PercentageListTileWithTagsWidget(),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
