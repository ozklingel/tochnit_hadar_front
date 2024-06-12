import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/institutions_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgottenApprenticesScreen extends HookConsumerWidget {
  const ForgottenApprenticesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final forgottenPersonas =
        ref.watch(getForgottenApprenticesProvider).valueOrNull ??
            const ApprenticeStatusDto();

    final institutions = ref.watch(getInstitutionsProvider).valueOrNull ?? [];
    final selectedApprenticeStatusItem =
        useState(const ApprenticeStatusItemDto());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'חניכים נשכחים',
          style: TextStyles.s20w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selectedApprenticeStatusItem.value.id.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  institutions
                      .singleWhere(
                        (element) =>
                            element.id == selectedApprenticeStatusItem.value.id,
                        orElse: () => const InstitutionDto(),
                      )
                      .name,
                  style: TextStyles.s24w500cGrey2,
                ),
              ),
            ),
          const ExportToExcelBar(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'חניכים שעברו מעל 100 יום מיצירת קשר איתם',
                  style: TextStyles.s16w500cGrey2,
                ),
                const SizedBox(height: 12),
                Text(
                  'סה"כ'
                  ' '
                  '${forgottenPersonas.total}',
                  style: TextStyles.s14w300cGray5,
                ),
              ],
            ),
          ),
          Expanded(
            child: InstitutionsView(
              items: forgottenPersonas.items,
              institutions: institutions,
              onTap: (val) => selectedApprenticeStatusItem.value = val,
            ),
          ),
        ],
      ),
    );
  }
}
