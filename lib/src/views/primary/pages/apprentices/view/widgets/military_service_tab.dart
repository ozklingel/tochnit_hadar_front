import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class MilitaryServiceTabView extends HookConsumerWidget {
  const MilitaryServiceTabView({
    super.key,
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final compound =
        ref.watch(compoundControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == persona.militaryCompoundId,
                  orElse: () => const CompoundDto(),
                ) ??
            const CompoundDto();
    final isEditMode = useState(false);
    final compoundController = useTextEditingController(
      text: compound.name,
      keys: [persona],
    );
    final unitController = useTextEditingController(
      text: persona.militaryUnit,
      keys: [persona],
    );
    final positionNewController = useTextEditingController(
      text: persona.militaryPositionNew,
      keys: [persona],
    );
    final positionOldController = useTextEditingController(
      text: persona.militaryPositionOld,
      keys: [persona],
    );
    final selectedCompound = useState(compound);
    final selectedServiceType = useState(MilitaryServiceType.commando);
    final enrollmentDate =
        useState(persona.militaryDateOfEnlistment.asDateTime);
    final dischargeDate = useState(persona.militaryDateOfDischarge.asDateTime);

    useListenable(unitController);
    useListenable(positionOldController);
    useListenable(positionNewController);

    return Form(
      child: AnimatedSwitcher(
        duration: Consts.defaultDurationM,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          ),
        ),
        child: DetailsCard(
          title: 'צבא',
          trailing: IconButton(
            onPressed: () => isEditMode.value = true,
            icon: const Icon(FluentIcons.edit_24_regular),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(36)),
                      borderSide: BorderSide(
                        color: AppColors.gray5,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'צבא',
                      style: TextStyles.s20w400.copyWith(
                        color: AppColors.gray1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ref.watch(compoundControllerProvider).when(
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (error, stack) => const Center(
                            child: Text('failed to load bases'),
                          ),
                          data: (compounds) => InputFieldContainer(
                            label: 'בסיס',
                            data: isEditMode.value ? null : compound.name,
                            isRequired: true,
                            child: GeneralDropdownButton<CompoundDto>(
                              value: selectedCompound.value.name,
                              textStyle: TextStyles.s16w400cGrey5,
                              items: compounds,
                              stringMapper: (e) => e.name,
                              onChanged: (value) =>
                                  selectedCompound.value = value!,
                              onMenuStateChange: (isOpen) {},
                              searchController: compoundController,
                            ),
                          ),
                        ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'סוג שירות',
                      data: isEditMode.value
                          ? null
                          : selectedServiceType.value.hebrewName,
                      child: GeneralDropdownButton<MilitaryServiceType>(
                        value: selectedServiceType.value.hebrewName,
                        textStyle: TextStyles.s16w400cGrey5,
                        items: MilitaryServiceType.values,
                        stringMapper: (e) => e.hebrewName,
                        onChanged: (value) =>
                            selectedServiceType.value = value!,
                      ),
                    ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'שיוך יחידתי',
                      data: persona.militaryUnit,
                      child: TextFormField(
                        controller: unitController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ריק';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'תפקיד נוכחי',
                      data:
                          isEditMode.value ? null : persona.militaryPositionNew,
                      child: TextFormField(
                        controller: positionNewController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ריק';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'תפקיד קודם',
                      data:
                          isEditMode.value ? null : persona.militaryPositionOld,
                      child: TextFormField(
                        controller: positionOldController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ריק';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'תאריך גיוס',
                      data: isEditMode.value
                          ? null
                          : persona.militaryDateOfEnlistment.asDateTime
                              .asDayMonthYearShortDot,
                      isRequired: true,
                      child: InkWell(
                        onTap: () async {
                          final newDate = await showDatePicker(
                            context: context,
                            initialDate: enrollmentDate.value,
                            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                            lastDate:
                                DateTime.now().add(const Duration(days: 99000)),
                          );

                          if (newDate == null) {
                            return;
                          }

                          enrollmentDate.value = newDate;
                        },
                        borderRadius: BorderRadius.circular(36),
                        child: IgnorePointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: DateFormat('dd/MM/yy')
                                  .format(enrollmentDate.value),
                              hintStyle: TextStyles.s16w400cGrey2.copyWith(
                                color: AppColors.grey5,
                              ),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.grey5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    InputFieldContainer(
                      label: 'תאריך שחרור',
                      data: isEditMode.value
                          ? null
                          : persona.militaryDateOfDischarge.asDateTime
                              .asDayMonthYearShortDot,
                      child: InkWell(
                        onTap: () async {
                          final newDate = await showDatePicker(
                            context: context,
                            initialDate: dischargeDate.value,
                            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                            lastDate:
                                DateTime.now().add(const Duration(days: 99000)),
                          );

                          if (newDate == null) {
                            return;
                          }

                          dischargeDate.value = newDate;
                        },
                        borderRadius: BorderRadius.circular(36),
                        child: IgnorePointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: DateFormat('dd/MM/yy')
                                  .format(dischargeDate.value),
                              hintStyle: TextStyles.s16w400cGrey2.copyWith(
                                color: AppColors.grey5,
                              ),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.grey5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isEditMode.value) ...[
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'שמירה',
                              onPressed: (unitController.text.isEmpty ||
                                      positionOldController.text.isEmpty ||
                                      positionNewController.text.isEmpty)
                                  ? null
                                  : () async {
                                      final result = await ref
                                          .read(
                                            personasControllerProvider.notifier,
                                          )
                                          .edit(
                                            persona: persona.copyWith(
                                              militaryCompoundId:
                                                  selectedCompound.value.id,
                                              militaryUnit: unitController.text,
                                              militaryPositionNew:
                                                  positionNewController.text,
                                              militaryPositionOld:
                                                  positionOldController.text,
                                              militaryDateOfEnlistment:
                                                  enrollmentDate.value
                                                      .toIso8601String(),
                                              militaryDateOfDischarge:
                                                  dischargeDate.value
                                                      .toIso8601String(),
                                            ),
                                          );

                                      if (result) {
                                        isEditMode.value = false;
                                      } else {
                                        Toaster.show(
                                          'שגיאה בעת שמירת השינויים',
                                        );
                                      }
                                    },
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: LargeFilledRoundedButton(
                              label: 'ביטול',
                              onPressed: () => isEditMode.value = false,
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.blue02,
                              textStyle: TextStyles.s14w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
