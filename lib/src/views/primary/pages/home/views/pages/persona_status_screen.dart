// ignore_for_file: unused_element

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/apprentices_status_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/send_status_messagecreen.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/export_excel_bar.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/pages/widgets/institutions_view.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonaStatusScreen extends HookConsumerWidget {
  const PersonaStatusScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initIndex,
  });

  final String title;
  final String subtitle;
  final int initIndex;

  @override
  Widget build(BuildContext context, ref) {
    final screenController =
        ref.watch(apprenticesStatusControllerProvider).valueOrNull ??
            const ApprenticeStatusDto();
    final institutions = ref.watch(getInstitutionsProvider).valueOrNull ?? [];
    final personas = ref.watch(getPersonasProvider).valueOrNull ?? [];
    final tabController = useTabController(
      initialLength: 3,
      initialIndex: initIndex,
    );
    final selectedApprenticeStatusItem =
        useState(const ApprenticeStatusItemDto());
    useListenable(tabController);
    final selectedInstitution = institutions.singleWhere(
      (element) => element.id == selectedApprenticeStatusItem.value.id,
      orElse: () => const InstitutionDto(),
    );

    final selectedPersonas = personas
        .where((element) => element.institutionId == selectedInstitution.id)
        .toList();

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
            onPressed: () => selectedApprenticeStatusItem.value.id.isEmpty
                ? Navigator.of(context).pop()
                : selectedApprenticeStatusItem.value =
                    const ApprenticeStatusItemDto(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (selectedApprenticeStatusItem.value.id.isNotEmpty)
              Text(
                selectedInstitution.name,
                style: TextStyles.s24w500cGrey2,
              ),
            const ExportToExcelBar(),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.shades300,
                      ),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: TextStyles.s16w500cBlue2,
                        unselectedLabelStyle: TextStyles.s16w400cGrey2,
                        splashBorderRadius: BorderRadius.circular(36),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.blue06,
                        ),
                        tabs: const [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("כללי"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("שיחות"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("מפגשים"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tabController.index == 0
                        ? 'חניכים עם ציון כללי- לא תקין'
                        : tabController.index == 1
                            ? 'חניכים שעברו מעל 45 יום משיחה איתם'
                            : 'חניכים שעברו מעל 60 יום ממפגש איתם',
                    style: TextStyles.s16w500cGrey2,
                  ),
                  const SizedBox(height: 6),
                  if (selectedPersonas.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          'סה”כ ${screenController.total}',
                          style: TextStyles.s14w300cGray5,
                        ),
                        if (selectedApprenticeStatusItem
                            .value.id.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            FluentIcons.arrow_trending_24_regular,
                            color: AppColors.green1,
                          ),
                          const SizedBox(width: 2),
                          const Text('2%'),
                        ],
                      ],
                    ),
                  Expanded(
                    child: selectedApprenticeStatusItem.value.id.isEmpty
                        ? InstitutionsView(
                            institutions: institutions,
                            items: screenController.items,
                            onTap: (apprentice) =>
                                selectedApprenticeStatusItem.value = apprentice,
                          )
                        : _ApprenticeStatusView(
                            tabController: tabController,
                            selectedApprenticeStatusItem:
                                selectedApprenticeStatusItem,
                            selectedPersonas: selectedPersonas,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprenticeStatusView extends StatelessWidget {
  const _ApprenticeStatusView({
    super.key,
    required this.tabController,
    required this.selectedApprenticeStatusItem,
    required this.selectedPersonas,
  });

  final TabController tabController;
  final ValueNotifier<ApprenticeStatusItemDto> selectedApprenticeStatusItem;
  final List<PersonaDto> selectedPersonas;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _PersonasView(
          id: selectedApprenticeStatusItem.value.id,
          personas: selectedPersonas,
        ),
        _PersonasView(
          id: selectedApprenticeStatusItem.value.id,
          personas: selectedPersonas,
        ),
        _PersonasView(
          id: selectedApprenticeStatusItem.value.id,
          personas: selectedPersonas,
        ),
      ],
    );
  }
}

class _PersonasView extends HookWidget {
  const _PersonasView({
    super.key,
    required this.id,
    required this.personas,
  });

  final String id;
  final List<PersonaDto> personas;

  @override
  Widget build(BuildContext context) {
    final selectedPersonas = useState(<PersonaDto>[]);

    // Logger().d(selectedPersonas.value.length);

    return personas.isEmpty
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
              if (id.isNotEmpty) ...[
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
                          builder: (context) => SendStatusMessagecreen(
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
                  children: personas.map(
                    (e) {
                      void selectPersona() {
                        if (selectedPersonas.value.contains(e)) {
                          selectedPersonas.value = [
                            ...selectedPersonas.value
                                .where((element) => element.id != e.id),
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
                        isSelected: selectedPersonas.value.contains(e),
                        onLongPress: selectPersona,
                        onTap: selectPersona,
                        tags: const [
                          'עברו 78 ימים מהשיחה האחרונה',
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
  }
}
