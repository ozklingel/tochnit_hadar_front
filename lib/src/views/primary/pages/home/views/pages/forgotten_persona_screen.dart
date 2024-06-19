import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices_by_institution.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/forgotten_mosad_apprentices.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/send_status_message_screen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/institutions_view.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
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

    final institutions = ref.watch(getInstitutionsProvider);
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
            onPressed: () => selectedApprenticeStatusItem.value.id.isEmpty
                ? Navigator.of(context).pop()
                : selectedApprenticeStatusItem.value =
                    const ApprenticeStatusItemDto(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: institutions.isLoading
          ? const LoadingState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selectedApprenticeStatusItem.value.id.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        (institutions.valueOrNull ?? [])
                            .singleWhere(
                              (element) =>
                                  element.id ==
                                  selectedApprenticeStatusItem.value.id,
                              orElse: () => const InstitutionDto(),
                            )
                            .name,
                        style: TextStyles.s24w500cGrey2,
                      ),
                    ),
                  ),
                const ExportToExcelBar(),
                Expanded(
                  child: selectedApprenticeStatusItem.value.id.isEmpty
                      ? InstitutionsView(
                          items: forgottenPersonas.items,
                          institutions: (institutions.valueOrNull ?? []),
                          onTap: (val) =>
                              selectedApprenticeStatusItem.value = val,
                          topWidget: _TotalCounterBar(
                            total: forgottenPersonas.total,
                          ),
                        )
                      : _PersonasView(
                          institutionId: selectedApprenticeStatusItem.value.id,
                        ),
                ),
              ],
            ),
    );
  }
}

class _TotalCounterBar extends StatelessWidget {
  const _TotalCounterBar({
    required this.total,
    this.percent = 0,
  });

  final int total;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'חניכים שעברו מעל 100 יום מיצירת קשר איתם',
            style: TextStyles.s16w500cGrey2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'סה"כ'
                ' '
                '$total',
                style: TextStyles.s14w300cGray5,
              ),
              if (percent != 0) ...[
                const SizedBox(width: 8),
                if (percent > 0)
                  const Icon(
                    FluentIcons.arrow_trending_24_regular,
                    color: AppColors.green1,
                    size: 16,
                  )
                else
                  const Icon(
                    FluentIcons.arrow_trending_down_24_regular,
                    color: AppColors.red1,
                    size: 16,
                  ),
                Text(
                  '$percent%',
                  style: TextStyles.s12w300cGray5,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonasView extends HookConsumerWidget {
  const _PersonasView({
    required this.institutionId,
  });

  final String institutionId;

  @override
  Widget build(BuildContext context, ref) {
    final screenController = ref.watch(
      getForgottenApprenticesByInstitutionProvider(
        institutionId: institutionId,
      ),
    );
    final forgottenApprentices =
        screenController.valueOrNull ?? const ForgottenMosadApprenticesDto();
    final selectedPersonas = useState(<PersonaDto>[]);
    final filteredPersonas = (ref.watch(getPersonasProvider).valueOrNull ?? [])
        .where(
          (element) => forgottenApprentices.items.any(
            (e) => e.id == element.id,
          ),
        )
        .toList();

    // Logger().d(forgottenApprentices.items);

    return screenController.isLoading
        ? const LoadingState()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TotalCounterBar(
                total: filteredPersonas.length,
                percent: forgottenApprentices.percentage,
              ),
              Expanded(
                child: filteredPersonas.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Assets.illustrations.thankfulHeartSignEyesOpen.svg(
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                          const Text(
                            'אין חניכים נשכחים - שעברו 100 יום מאינטראקציה איתם ',
                            style: TextStyles.s20w500cGrey2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'חניכים שעברו 100 יום מאינטראקציה איתם, יופיעו כאן',
                            style: TextStyles.s14w400cGrey1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          if (institutionId.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.blue04,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SendStatusMessagecreen(
                                        recipients: selectedPersonas.value
                                            .map((e) => e.id)
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'שליחת הודעה ',
                                    style: TextStyles.s14w300cBlue2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView(
                              children: filteredPersonas
                                  .where(
                                (element) => (screenController.valueOrNull ??
                                        const ForgottenMosadApprenticesDto())
                                    .items
                                    .any((e) => e.id == element.id),
                              )
                                  .map(
                                (e) {
                                  void selectPersona() {
                                    if (selectedPersonas.value.contains(e)) {
                                      selectedPersonas.value = [
                                        ...selectedPersonas.value.where(
                                          (element) => element.id != e.id,
                                        ),
                                      ];
                                    } else {
                                      selectedPersonas.value = [
                                        ...selectedPersonas.value,
                                        e,
                                      ];
                                    }
                                  }

                                  return ListTileWithTagsCard(
                                    avatar: e.avatar,
                                    name: e.fullName,
                                    isSelected:
                                        selectedPersonas.value.contains(e),
                                    onLongPress: selectPersona,
                                    onTap: selectPersona,
                                    tags: [
                                      'עברו ${forgottenApprentices.items.singleWhere(
                                            (element) => element.id == e.id,
                                            orElse: () =>
                                                const ForgottenApprenticeDto(),
                                          ).gap} ימים מהשיחה האחרונה',
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
  }
}
