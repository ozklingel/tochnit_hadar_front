import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/persona_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/row_icon_button.dart';
import 'package:hadar_program/src/views/widgets/cards/details_card.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PersonalInfoTabView extends ConsumerWidget {
  const PersonalInfoTabView({
    super.key,
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        _GeneralSection(persona: persona),
        _DatesSection(persona: persona),
        _FamilySection(persona: persona),
        _EducationSection(persona: persona),
        _WorkSection(persona: persona),
      ],
    );
  }
}

class _WorkSection extends HookConsumerWidget {
  const _WorkSection({
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final isEditMode = useState(false);
    final workStatus = useTextEditingController(text: persona.workStatus);
    final workOccupation =
        useTextEditingController(text: persona.workOccupation);
    final workPlace = useTextEditingController(text: persona.workPlace);
    final workType = useTextEditingController(text: persona.workType);

    return DetailsCard(
      title: 'עיסוק',
      trailing: auth.valueOrNull?.role == UserRole.ahraiTohnit
          ? RowIconButton(
              onPressed: () => isEditMode.value = !isEditMode.value,
              icon: const Icon(FluentIcons.edit_24_regular),
            )
          : null,
      child: Column(
        children: isEditMode.value
            ? [
                InputFieldContainer(
                  label: 'סטטוס',
                  child: TextField(
                    controller: workStatus,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'עיסוק',
                  child: TextField(
                    controller: workOccupation,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'סוג עבודה',
                  child: TextField(
                    controller: workType,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מקום עבודה',
                  child: TextField(
                    controller: workPlace,
                  ),
                ),
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: () async {
                    final result = await ref
                        .read(personasControllerProvider.notifier)
                        .edit(
                          persona: persona.copyWith(
                            workStatus: workStatus.text,
                            workOccupation: workOccupation.text,
                            workPlace: workPlace.text,
                            workType: workType.text,
                          ),
                        );

                    if (result) {
                      isEditMode.value = false;
                    }
                  },
                ),
              ]
            : [
                DetailsRowItem(
                  label: 'סטטוס',
                  data: persona.workStatus,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'עיסוק',
                  data: persona.workOccupation,
                ),
                const SizedBox(height: 12),
                // DetailsRowItem(
                //   label: 'מקום לימודים',
                //   data: persona.educationalInstitution,
                // ),
                // const SizedBox(height: 12),
                // DetailsRowItem(
                //   label: 'פקולטה',
                //   data: persona.educationFaculty,
                // ),
                // const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'סוג עבודה',
                  data: persona.workType,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מקום עבודה',
                  data: persona.workPlace,
                ),
              ],
      ),
    );
  }
}

class _EducationSection extends HookConsumerWidget {
  const _EducationSection({
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final isEditMode = useState(false);
    final institution =
        useTextEditingController(text: persona.highSchoolInstitution);
    final ravMelamedName = useTextEditingController(
      text: persona.highSchoolRavMelamedName,
    );
    final ravMelamedPhone = useTextEditingController(
      text: persona.highSchoolRavMelamedPhone,
    );

    return DetailsCard(
      title: 'לימודי תיכון',
      trailing: auth.valueOrNull?.role == UserRole.ahraiTohnit
          ? RowIconButton(
              onPressed: () => isEditMode.value = !isEditMode.value,
              icon: const Icon(FluentIcons.edit_24_regular),
            )
          : null,
      child: Column(
        children: isEditMode.value
            ? [
                InputFieldContainer(
                  label: 'מוסד לימודים',
                  child: TextField(
                    controller: institution,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'שם ר”מ',
                  child: TextField(
                    controller: ravMelamedName,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'טלפון ר”מ',
                  child: TextField(
                    controller: ravMelamedPhone,
                  ),
                ),
                const SizedBox(height: 12),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: (institution.text.isEmpty ||
                          ravMelamedName.text.isEmpty ||
                          ravMelamedPhone.text.isEmpty)
                      ? null
                      : () async {
                          final result = await ref
                              .read(personasControllerProvider.notifier)
                              .edit(
                                persona: persona.copyWith(
                                  highSchoolInstitution: institution.text,
                                  highSchoolRavMelamedName: ravMelamedName.text,
                                  highSchoolRavMelamedPhone:
                                      ravMelamedPhone.text,
                                ),
                              );

                          if (result) {
                            isEditMode.value = false;
                          }
                        },
                ),
              ]
            : [
                DetailsRowItem(
                  label: 'מוסד לימודים',
                  data: persona.highSchoolInstitution,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'שם ר”מ',
                  data: persona.highSchoolRavMelamedName,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'טלפון ר”מ',
                  onTapData: () =>
                      launchCall(phone: persona.highSchoolRavMelamedPhone),
                  data: persona.highSchoolRavMelamedPhone.format,
                ),
              ],
      ),
    );
  }
}

class _FamilySection extends HookConsumerWidget {
  const _FamilySection({
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final isEditMode = useState(false);
    final contact1Relationship = useState(persona.contact1Relationship);
    final contact1FirstName =
        useTextEditingController(text: persona.contact1FirstName);
    final contact1LastName =
        useTextEditingController(text: persona.contact1LastName);
    final contact1Phone = useTextEditingController(text: persona.contact1Phone);
    final contact1Email = useTextEditingController(text: persona.contact1Email);
    final contact2Relationship = useState(persona.contact2Relationship);
    final contact2FirstName =
        useTextEditingController(text: persona.contact2FirstName);
    final contact2LastName =
        useTextEditingController(text: persona.contact2LastName);
    final contact2Phone = useTextEditingController(text: persona.contact2Phone);
    final contact2Email = useTextEditingController(text: persona.contact2Email);
    final contact3Relationship = useState(persona.contact3Relationship);
    final contact3FirstName =
        useTextEditingController(text: persona.contact3FirstName);
    final contact3LastName =
        useTextEditingController(text: persona.contact3LastName);
    final contact3Phone = useTextEditingController(text: persona.contact3Phone);
    final contact3Email = useTextEditingController(text: persona.contact3Email);

    return DetailsCard(
      title: 'משפחה',
      trailing: auth.valueOrNull?.role == UserRole.ahraiTohnit
          ? RowIconButton(
              onPressed: () => isEditMode.value = !isEditMode.value,
              icon: const Icon(FluentIcons.edit_24_regular),
            )
          : null,
      child: Column(
        children: isEditMode.value
            ? [
                ...[
                  InputFieldContainer(
                    label: 'איש קשר 1 - קרבה',
                    child: PersonaDropdownButton(
                      value: contact1Relationship.value.name,
                      items: Relationship.values.map((e) => e.name).toList(),
                      onChanged: (value) => contact1Relationship.value =
                          Relationship.values.firstWhere(
                        (e) => e.name == value,
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          contact1Relationship.value = Relationship.other;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 1 - שם פרטי',
                    child: TextField(
                      controller: contact1FirstName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 1 - שם משפחה',
                    child: TextField(
                      controller: contact1LastName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 1 - טלפון',
                    child: TextField(
                      controller: contact1Phone,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 1 - אימייל',
                    child: TextField(
                      controller: contact1Email,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                ...[
                  InputFieldContainer(
                    label: 'איש קשר 2 - קרבה',
                    child: PersonaDropdownButton(
                      value: contact2Relationship.value.name,
                      items: Relationship.values.map((e) => e.name).toList(),
                      onChanged: (value) => contact2Relationship.value =
                          Relationship.values.firstWhere(
                        (e) => e.name == value,
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          contact2Relationship.value = Relationship.other;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 2 - שם פרטי',
                    child: TextField(
                      controller: contact2FirstName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 2 - שם משפחה',
                    child: TextField(
                      controller: contact2LastName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 2 - טלפון',
                    child: TextField(
                      controller: contact2Phone,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 2 - אימייל',
                    child: TextField(
                      controller: contact2Email,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                ...[
                  InputFieldContainer(
                    label: 'איש קשר 3 - קרבה',
                    child: PersonaDropdownButton(
                      value: contact3Relationship.value.name,
                      items: Relationship.values.map((e) => e.name).toList(),
                      onChanged: (value) => contact3Relationship.value =
                          Relationship.values.firstWhere(
                        (e) => e.name == value,
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          contact3Relationship.value = Relationship.other;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 3 - שם פרטי',
                    child: TextField(
                      controller: contact2FirstName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 3 - שם משפחה',
                    child: TextField(
                      controller: contact2LastName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 3 - טלפון',
                    child: TextField(
                      controller: contact2Phone,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputFieldContainer(
                    label: 'איש קשר 3 - אימייל',
                    child: TextField(
                      controller: contact3Email,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: () async {
                    final result = await ref
                        .read(
                          personasControllerProvider.notifier,
                        )
                        .edit(
                          persona: persona.copyWith(
                            contact1Relationship: contact1Relationship.value,
                            contact1FirstName: contact1FirstName.text,
                            contact1LastName: contact1LastName.text,
                            contact1Phone: contact1Phone.text,
                            contact2Relationship: contact2Relationship.value,
                            contact2FirstName: contact2FirstName.text,
                            contact2LastName: contact2LastName.text,
                            contact2Phone: contact2Phone.text,
                            contact3Relationship: contact3Relationship.value,
                            contact3FirstName: contact3FirstName.text,
                            contact3LastName: contact3LastName.text,
                            contact3Phone: contact3Phone.text,
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
                ),
              ]
            : [
                if (persona.contact1FirstName.isEmpty)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FluentIcons.add_24_regular,
                    ),
                  )
                else
                  _ContactRow(
                    email: persona.contact1Email,
                    fullName:
                        persona.contact1FirstName + persona.contact1LastName,
                    phone: persona.contact1Phone,
                    relationship: persona.contact1Relationship,
                  ),
                if (persona.contact2FirstName.isNotEmpty)
                  _ContactRow(
                    email: persona.contact2Email,
                    fullName:
                        persona.contact2FirstName + persona.contact2LastName,
                    phone: persona.contact2Phone,
                    relationship: persona.contact2Relationship,
                  ),
                if (persona.contact3FirstName.isNotEmpty)
                  _ContactRow(
                    email: persona.contact3Email,
                    fullName:
                        persona.contact3FirstName + persona.contact3LastName,
                    phone: persona.contact3Phone,
                    relationship: persona.contact3Relationship,
                  ),
              ],
      ),
    );
  }
}

class _DatesSection extends HookConsumerWidget {
  const _DatesSection({
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final isEditMode = useState(false);
    final bdController = useState(persona.dateOfBirth.asDateTime);

    return DetailsCard(
      title: 'תאריכים',
      trailing: auth.valueOrNull?.role == UserRole.ahraiTohnit
          ? RowIconButton(
              onPressed: () => isEditMode.value = !isEditMode.value,
              icon: const Icon(FluentIcons.edit_24_regular),
            )
          : null,
      child: Column(
        children: isEditMode.value
            ? [
                InputFieldContainer(
                  label: 'יום הולדת',
                  isRequired: true,
                  child: InkWell(
                    onTap: () async {
                      final newDate = await showDatePicker(
                        context: context,
                        initialDate: bdController.value,
                        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                        lastDate:
                            DateTime.now().add(const Duration(days: 99000)),
                      );

                      if (newDate == null) {
                        return;
                      }

                      bdController.value = newDate;
                    },
                    borderRadius: BorderRadius.circular(36),
                    child: IgnorePointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText:
                              DateFormat('dd/MM/yy').format(bdController.value),
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
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: () async {
                    final result = await ref
                        .read(personasControllerProvider.notifier)
                        .edit(
                          persona: persona.copyWith(
                            dateOfBirth: bdController.value.toIso8601String(),
                          ),
                        );

                    if (result) {
                      isEditMode.value = false;
                    }
                  },
                ),
              ]
            : [
                DetailsRowItem(
                  label: 'יום הולדת עברי',
                  data: persona.dateOfBirth.asDateTime.he,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'יום הולדת לועזי',
                  data: persona.dateOfBirth.asDateTime.asDayMonthYearShortDot,
                ),
                // missing on backend
                // const SizedBox(height: 12),
                // const DetailsRowItem(
                //   label: 'יום נישואים',
                //   data: 'ט”ו אב',
                // ),
              ],
      ),
    );
  }
}

class _GeneralSection extends HookConsumerWidget {
  const _GeneralSection({
    required this.persona,
  });

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    final isEditMode = useState(false);
    final tzController = useTextEditingController(text: persona.teudatZehut);
    final emailController = useTextEditingController(text: persona.email);
    final cityController = useState(persona.address.city);
    final streetController =
        useTextEditingController(text: persona.address.street);
    final citySearchController = useTextEditingController();
    final houseNumberController =
        useTextEditingController(text: persona.address.houseNumber);
    final maritalStatusController =
        useTextEditingController(text: persona.maritalStatus);
    final phoneController = useTextEditingController(text: persona.phone);

    useListenable(tzController);
    useListenable(emailController);
    useListenable(streetController);
    useListenable(houseNumberController);
    useListenable(maritalStatusController);
    useListenable(phoneController);

    return DetailsCard(
      title: 'כללי',
      trailing: auth.valueOrNull?.role.isProgramDirector ?? false
          ? RowIconButton(
              onPressed: () => isEditMode.value = !isEditMode.value,
              icon: const Icon(FluentIcons.edit_24_regular),
            )
          : null,
      child: Column(
        children: isEditMode.value
            ? [
                InputFieldContainer(
                  label: 'תעודת זהות',
                  isRequired: true,
                  child: TextField(
                    controller: tzController,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'אימייל',
                  isRequired: true,
                  child: TextField(
                    controller: emailController,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'יישוב',
                  isRequired: true,
                  child: ref.watch(getCitiesListProvider).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        error: (error, stack) => Center(
                          child: Text(error.toString()),
                        ),
                        data: (cities) => PersonaDropdownButton(
                          value: cityController.value,
                          items: cities,
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              citySearchController.clear();
                            }
                          },
                          onChanged: (value) =>
                              cityController.value = value ?? '',
                          dropdownSearchData: DropdownSearchData(
                            searchController: citySearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: TextField(
                              controller: citySearchController,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(),
                                enabledBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                hintText: 'חיפוש',
                                hintStyle: TextStyles.s14w400,
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .toLowerCase()
                                  .trim()
                                  .contains(
                                    searchValue.toLowerCase().trim(),
                                  );
                            },
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'רחוב',
                  isRequired: true,
                  child: TextField(
                    controller: streetController,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מס\' בית',
                  isRequired: true,
                  child: TextField(
                    controller: houseNumberController,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מצב משפחתי',
                  isRequired: true,
                  child: TextField(
                    controller: maritalStatusController,
                  ),
                ),
                const SizedBox(height: 12),
                InputFieldContainer(
                  label: 'מספר טלפון',
                  isRequired: true,
                  child: TextField(
                    controller: phoneController,
                  ),
                ),
                const SizedBox(height: 24),
                AcceptCancelButtons(
                  onPressedCancel: () => isEditMode.value = false,
                  okText: 'שמירה',
                  onPressedOk: (tzController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          cityController.value.isEmpty ||
                          streetController.text.isEmpty ||
                          houseNumberController.text.isEmpty ||
                          maritalStatusController.text.isEmpty ||
                          phoneController.text.isEmpty)
                      ? null
                      : () async {
                          final res = await ref
                              .read(personasControllerProvider.notifier)
                              .edit(
                                persona: persona.copyWith(
                                  teudatZehut: tzController.text,
                                  email: emailController.text,
                                  address: persona.address.copyWith(
                                    city: cityController.value,
                                    street: streetController.text,
                                    houseNumber: houseNumberController.text,
                                  ),
                                  maritalStatus: maritalStatusController.text,
                                  phone: phoneController.text,
                                ),
                              );

                          if (res) {
                            isEditMode.value = false;
                          }
                        },
                ),
              ]
            : [
                DetailsRowItem(
                  label: 'תעודת זהות',
                  data: persona.teudatZehut,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'אימייל',
                  data: persona.email,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'כתובת',
                  data: persona.address.fullAddress,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'אזור',
                  data: persona.address.region,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מצב משפחתי',
                  data: persona.maritalStatus,
                ),
                const SizedBox(height: 12),
                DetailsRowItem(
                  label: 'מספר טלפון',
                  data: persona.phone.format,
                ),
              ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.relationship,
    required this.phone,
    required this.fullName,
    required this.email,
  });

  final Relationship relationship;
  final String phone;
  final String fullName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyles.s14w400,
            children: [
              TextSpan(
                text: relationship.name,
                style: const TextStyle(
                  color: AppColors.gray5,
                ),
              ),
              const TextSpan(text: '\t'),
              TextSpan(text: fullName),
            ],
          ),
        ),
        _ContactButtons(
          phone: phone,
          email: email,
        ),
      ],
    );
  }
}

class _ContactButtons extends ConsumerWidget {
  const _ContactButtons({
    required this.phone,
    required this.email,
  });

  final String phone;
  final String email;

  @override
  Widget build(BuildContext context, ref) {
    // final auth = ref.watch(authServiceProvider);

    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            phone.format,
            style: TextStyles.s14w400.copyWith(
              color: AppColors.gray2,
            ),
          ),
        ),
        const Spacer(),
        RowIconButton(
          onPressed: () => launchSms(phone: [phone]),
          icon: const Icon(FluentIcons.chat_24_regular),
        ),
        const SizedBox(width: 4),
        RowIconButton(
          icon: Assets.icons.whatsapp.svg(
            height: 20,
          ),
          onPressed: () => launchWhatsapp(phone: phone),
        ),
        const SizedBox(width: 4),
        RowIconButton(
          onPressed: () => launchCall(phone: phone),
          icon: const Icon(FluentIcons.call_24_regular),
        ),
        const SizedBox(width: 4),
        RowIconButton(
          onPressed: () => launchEmail(email: email),
          icon: const Icon(FluentIcons.mail_24_regular),
        ),
      ],
    );
  }
}
