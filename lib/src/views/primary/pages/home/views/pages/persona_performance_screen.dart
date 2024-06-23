import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/apprentices_status_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/institutions_view.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/performance_total_counter_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonaPerformanceScreen extends HookConsumerWidget {
  const PersonaPerformanceScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, ref) {
    final institutions = ref.watch(getInstitutionsProvider).valueOrNull ?? [];
    final screenController =
        ref.watch(apprenticesStatusControllerProvider).valueOrNull ??
            const ApprenticeStatusDto();

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
          PerformanceTotalCounterBar(
            label: 'מלווים מכלל המוסדות',
            total: screenController.total,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Consts.defaultDurationXL,
              child: InstitutionsView(
                label: 'מלווים',
                items: screenController.items,
                institutions: institutions,
                onTap: (val) => PersonaPerformanceByInstitutionRouteData(
                  id: val.id,
                  title: title,
                ).push(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
