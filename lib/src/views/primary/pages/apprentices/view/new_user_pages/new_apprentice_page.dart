import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/address_region.dart';
import 'package:hadar_program/src/core/enums/marital_status.dart';
import 'package:hadar_program/src/core/enums/matsbar_status.dart';
import 'package:hadar_program/src/core/enums/military_service_type.dart';
import 'package:hadar_program/src/core/enums/relationship.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/string.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/base/get_bases.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/new_user_pages/new_persona_appbar.dart';
import 'package:hadar_program/src/views/widgets/buttons/accept_cancel_buttons.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/missing_details_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class NewApprenticePage extends HookConsumerWidget {
  const NewApprenticePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    // general section
    final generalFirstName = useTextEditingController();
    final generalLastName = useTextEditingController();
    final generalTeudatZehut = useTextEditingController();
    final generalPhone = useTextEditingController();
    final generalEmail = useTextEditingController();
    final generalAddress = useTextEditingController();
    final generalRegion = useState(AddressRegion.unknown);
    final generalCity = useState('');
    final generalCitySearch = useTextEditingController();
    final genrealMaritalStatus = useState(MaritalStatus.unknown);
    // tohnit hadar section
    final thInstitution = useState(const InstitutionDto());
    final thInstitutionSearch = useTextEditingController();
    final thPeriod = useState('');
    final thMelave = useState(const PersonaDto());
    final thMelaveSearch = useTextEditingController();
    final thMatsbar = useState(MatsbarStatus.unknown);
    final thIsPaying = useState<bool?>(null);
    final thRoshMosadYearAName = useTextEditingController();
    final thRoshMosadYearAPhone = useTextEditingController();
    final thRoshMosadYearBName = useTextEditingController();
    final thRoshMosadYearBPhone = useTextEditingController();
    // military section
    final militaryArmyBase = useState(const CompoundDto());
    final militaryArmyBaseSearch = useTextEditingController();
    final militaryArmyServiceType = useState(MilitaryServiceType.unknown);
    final militaryArmyPreviousRole = useTextEditingController();
    final militaryArmyCurrentRole = useTextEditingController();
    final militaryArmyEnlistmentDate = useState<DateTime?>(null);
    final militaryArmyReleaseDate = useState<DateTime?>(null);
    // dates
    final datesDateOfBirth = useState<DateTime?>(null);
    final datesDateOfMarriage = useState<DateTime?>(null);
    // family
    final familyContact1Relationship = useState(Relationship.other);
    final familyContact1FirstName = useTextEditingController();
    final familyContact1LastName = useTextEditingController();
    final familyContact1Phone = useTextEditingController();
    final familyContact1Email = useTextEditingController();
    final familyShowContact2 = useState(false);
    final familyContact2Relationship = useState(Relationship.other);
    final familyContact2FirstName = useTextEditingController();
    final familyContact2LastName = useTextEditingController();
    final familyContact2Phone = useTextEditingController();
    final familyContact2Email = useTextEditingController();
    final familyShowContact3 = useState(false);
    final familyContact3Relationship = useState(Relationship.other);
    final familyContact3FirstName = useTextEditingController();
    final familyContact3LastName = useTextEditingController();
    final familyContact3Phone = useTextEditingController();
    final familyContact3Email = useTextEditingController();
    // high school
    final highSchoolName = useTextEditingController();
    final highSchoolRoshMosadName = useTextEditingController();
    final highSchoolRoshMosadPhone = useTextEditingController();
    // occupation
    final workStatus = useTextEditingController();
    final workName = useTextEditingController();
    final workPlace = useTextEditingController();
    final workType = useTextEditingController();

    final children = [
      // general section
      ...[
        const Text(
          'כללי',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'שם פרטי',
          isRequired: true,
          child: TextFormField(
            controller: generalFirstName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן שם פרטי של החניך',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'שם משפחה',
          isRequired: true,
          child: TextFormField(
            controller: generalLastName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן שם משפחה של החניך',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'תעודת זהות',
          isRequired: true,
          child: TextFormField(
            controller: generalTeudatZehut,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן תעודת זהות חניך',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'מספר טלפון',
          isRequired: true,
          child: Column(
            children: [
              TextFormField(
                controller: generalPhone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'empty';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'הזן מספר טלפון',
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Text(
                    'הזן מספרים בלבד, ללא רווחים',
                    style: TextStyles.s12w500cGray5,
                  ),
                ],
              ),
            ],
          ),
        ),
        InputFieldContainer(
          label: 'אימייל',
          child: TextFormField(
            controller: generalEmail,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן אימייל של החניך',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'כתובת',
          child: TextFormField(
            controller: generalAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן כתובת של החניך',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'אזור',
          isRequired: true,
          child: GeneralDropdownButton<AddressRegion>(
            stringMapper: (p0) => p0.name,
            value: generalRegion.value.name,
            onChanged: (value) =>
                generalRegion.value = value ?? AddressRegion.unknown,
            items: AddressRegion.regions,
          ),
        ),
        InputFieldContainer(
          label: 'עיר',
          isRequired: true,
          child: ref.watch(getCitiesListProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stack) => TextField(
                  onChanged: (value) => generalCity.value = value,
                  decoration: const InputDecoration(
                    hintText: 'יישוב / עיר',
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.grey6,
                      ),
                    ),
                  ),
                ),
                data: (cities) => GeneralDropdownButton<String>(
                  value: generalCity.value.isEmpty
                      ? cities.first
                      : generalCity.value,
                  items: cities,
                  onChanged: (value) => generalCity.value = value!,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      generalCitySearch.clear();
                    }
                  },
                  searchController: generalCitySearch,
                  searchMatchFunction: (item, searchValue) =>
                      item.value.toString().toLowerCase().trim().contains(
                            searchValue.toLowerCase().trim(),
                          ),
                ),
              ),
        ),
        InputFieldContainer(
          label: 'מצב משפחתי',
          child: GeneralDropdownButton<MaritalStatus>(
            stringMapper: (p0) => p0.name,
            value: genrealMaritalStatus.value.name,
            onChanged: (value) =>
                genrealMaritalStatus.value = value ?? MaritalStatus.unknown,
            items: MaritalStatus.values
                .whereNot((element) => element == MaritalStatus.unknown)
                .toList(),
          ),
        ),
      ],
      // tohnit hadar section
      ...[
        const Text(
          'תוכנית הדר',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'מוסד לימודים',
          isRequired: true,
          child: ref.watch(getInstitutionsProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (institutions) => GeneralDropdownButton<InstitutionDto>(
                  stringMapper: (p0) => p0.name,
                  value: thInstitution.value.name.ifEmpty ?? 'בחר מוסד לימודים',
                  onChanged: (value) =>
                      thInstitution.value = value ?? const InstitutionDto(),
                  items: institutions,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      thInstitutionSearch.clear();
                    }
                  },
                  searchController: thInstitutionSearch,
                  searchMatchFunction: (item, searchValue) =>
                      item.value.toString().toLowerCase().trim().contains(
                            searchValue.toLowerCase().trim(),
                          ),
                ),
              ),
        ),
        InputFieldContainer(
          label: 'מחזור תוכנית הדר',
          isRequired: true,
          child: GeneralDropdownButton<String>(
            value: thPeriod.value.ifEmpty ?? 'בחר מחזור',
            onChanged: (value) => thPeriod.value = value!,
            items: const [
              'א',
              'ב',
              'ג',
              'ד',
              'ה',
              'ו',
              'ז',
              'ח',
            ],
          ),
        ),
        InputFieldContainer(
          label: 'שיוך מלווה',
          isRequired: true,
          child: ref.watch(getPersonasProvider).when(
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (error, stack) => Text(error.toString()),
                data: (melavim) => GeneralDropdownButton<PersonaDto>(
                  stringMapper: (p0) => p0.fullName,
                  value: thMelave.value.fullName.ifEmpty ?? 'בחר מלווה',
                  onChanged: (value) => thMelave.value = value!,
                  items: melavim,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      thMelaveSearch.clear();
                    }
                  },
                  searchController: thMelaveSearch,
                  searchMatchFunction: (item, searchValue) =>
                      item.value.toString().toLowerCase().trim().contains(
                            searchValue.toLowerCase().trim(),
                          ),
                ),
              ),
        ),
        InputFieldContainer(
          label: 'מצב״ר - מצב רוחני',
          isRequired: true,
          child: GeneralDropdownButton<MatsbarStatus>(
            stringMapper: (p0) => p0.name,
            value: thMatsbar.value.name,
            onChanged: (value) =>
                thMatsbar.value = value ?? MatsbarStatus.unknown,
            items: MatsbarStatus.values
                .whereNot((element) => element == MatsbarStatus.unknown)
                .toList(),
          ),
        ),
        InputFieldContainer(
          label: 'משלם/לא משלם',
          isRequired: true,
          child: GeneralDropdownButton<bool>(
            stringMapper: (p0) => p0 ? 'משלם' : 'לא משלם',
            value: (thIsPaying.value ?? false) ? 'משלם' : 'לא משלם',
            onChanged: (value) => thIsPaying.value = value ?? false,
            items: const [
              true,
              false,
            ],
          ),
        ),
        InputFieldContainer(
          label: 'ר”מ שנה א',
          child: TextFormField(
            controller: thRoshMosadYearAName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן שם של ר”מ שנה א',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'טל’ ר”מ שנה א',
          child: TextFormField(
            controller: thRoshMosadYearAPhone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן מספר טלפון של ר”מ שנה א',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'ר”מ שנה ב',
          child: TextFormField(
            controller: thRoshMosadYearBName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן שם של ר”מ שנה ב',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'טל’ ר”מ שנה ב',
          child: TextFormField(
            controller: thRoshMosadYearBPhone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן מספר טלפון של ר”מ שנה ב',
            ),
          ),
        ),
      ],
      ...[
        const Text(
          'צבא',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'בסיס',
          isRequired: true,
          child: ref.watch(getCompoundListProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (institutions) => GeneralDropdownButton<CompoundDto>(
                  stringMapper: (p0) => p0.name,
                  value: militaryArmyBase.value.name.ifEmpty ?? 'בחר בסיס',
                  onChanged: (value) =>
                      militaryArmyBase.value = value ?? const CompoundDto(),
                  items: institutions,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      militaryArmyBaseSearch.clear();
                    }
                  },
                  searchController: militaryArmyBaseSearch,
                  searchMatchFunction: (item, searchValue) =>
                      item.value.toString().toLowerCase().trim().contains(
                            searchValue.toLowerCase().trim(),
                          ),
                ),
              ),
        ),
        InputFieldContainer(
          label: 'סוג שירות',
          isRequired: true,
          child: GeneralDropdownButton<MilitaryServiceType>(
            stringMapper: (p0) => p0.hebrewName,
            value: militaryArmyServiceType.value.name,
            onChanged: (value) => militaryArmyServiceType.value = value!,
            items: MilitaryServiceType.values
                .whereNot((element) => element == MilitaryServiceType.unknown)
                .toList(),
          ),
        ),
        InputFieldContainer(
          label: 'תפקיד קודם',
          child: TextFormField(
            controller: militaryArmyPreviousRole,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן תפקיד קודם',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'תפקיד נוכחי',
          child: TextFormField(
            controller: militaryArmyCurrentRole,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן תפקיד נוכחי',
            ),
          ),
        ),
        // TODO(noga-dev): extract this type of widget into common
        // widgets for easier reusability
        InputFieldContainer(
          label: 'תאריך גיוס',
          child: InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: militaryArmyEnlistmentDate.value ?? DateTime.now(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(const Duration(days: 365 * 99000)),
              );

              if (newDate == null) {
                return;
              }

              militaryArmyEnlistmentDate.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: militaryArmyEnlistmentDate.value == null
                      ? 'MM/DD/YY'
                      : DateFormat('dd/MM/yy')
                          .format(militaryArmyEnlistmentDate.value!),
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
        InputFieldContainer(
          label: 'תאריך שחרור',
          child: InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: militaryArmyReleaseDate.value ?? DateTime.now(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(const Duration(days: 365 * 99000)),
              );

              if (newDate == null) {
                return;
              }

              militaryArmyReleaseDate.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: militaryArmyReleaseDate.value == null
                      ? 'MM/DD/YY'
                      : DateFormat('dd/MM/yy')
                          .format(militaryArmyReleaseDate.value!),
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
      ],
      ...[
        const Text(
          'תאריכים',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'תאריך יום הולדת',
          isRequired: true,
          child: InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: datesDateOfBirth.value ?? DateTime.now(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(const Duration(days: 365 * 99000)),
              );

              if (newDate == null) {
                return;
              }

              datesDateOfBirth.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: datesDateOfBirth.value == null
                      ? 'MM/DD/YY'
                      : DateFormat('dd/MM/yy').format(datesDateOfBirth.value!),
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
        InputFieldContainer(
          label: 'תאריך יום נישואים',
          child: InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: datesDateOfMarriage.value ?? DateTime.now(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(const Duration(days: 365 * 99000)),
              );

              if (newDate == null) {
                return;
              }

              datesDateOfMarriage.value = newDate;
            },
            borderRadius: BorderRadius.circular(36),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: datesDateOfMarriage.value == null
                      ? 'MM/DD/YY'
                      : DateFormat('dd/MM/yy')
                          .format(datesDateOfMarriage.value!),
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
      ],
      ...[
        const Text(
          'משפחה',
          style: TextStyles.s20w400cGrey2,
        ),
        ...[
          const Text(
            'איש קשר 1',
            style: TextStyles.s16w400cGrey1,
          ),
          InputFieldContainer(
            label: 'קרבה',
            child: GeneralDropdownButton<Relationship>(
              value: familyContact1Relationship.value.name,
              onChanged: (value) => familyContact1Relationship.value = value!,
              items: Relationship.values,
            ),
          ),
          InputFieldContainer(
            label: 'שם פרטי',
            child: TextFormField(
              controller: familyContact1FirstName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם פרטי',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact1LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact1LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'מספר טלפון',
            child: Column(
              children: [
                TextFormField(
                  controller: familyContact1Phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'empty';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'הזן מספר טלפון',
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Text(
                      'הזן ספרות בלבד',
                      style: TextStyles.s12w500cGray5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          InputFieldContainer(
            label: 'מייל',
            child: TextFormField(
              controller: familyContact1Email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן כתובת אימייל',
              ),
            ),
          ),
        ],
        if (familyShowContact2.value) ...[
          const Text(
            'איש קשר 2',
            style: TextStyles.s16w400cGrey1,
          ),
          InputFieldContainer(
            label: 'קרבה',
            child: GeneralDropdownButton<Relationship>(
              value: familyContact2Relationship.value.name,
              onChanged: (value) => familyContact2Relationship.value = value!,
              items: Relationship.values,
            ),
          ),
          InputFieldContainer(
            label: 'שם פרטי',
            child: TextFormField(
              controller: familyContact2FirstName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם פרטי',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact2LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact2LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'מספר טלפון',
            child: Column(
              children: [
                TextFormField(
                  controller: familyContact2Phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'empty';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'הזן מספר טלפון',
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Text(
                      'הזן ספרות בלבד',
                      style: TextStyles.s12w500cGray5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          InputFieldContainer(
            label: 'מייל',
            child: TextFormField(
              controller: familyContact2Email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן כתובת אימייל',
              ),
            ),
          ),
        ],
        if (familyShowContact3.value) ...[
          const Text(
            'איש קשר 3',
            style: TextStyles.s16w400cGrey1,
          ),
          InputFieldContainer(
            label: 'קרבה',
            child: GeneralDropdownButton<Relationship>(
              value: familyContact3Relationship.value.name,
              onChanged: (value) => familyContact3Relationship.value = value!,
              items: Relationship.values,
            ),
          ),
          InputFieldContainer(
            label: 'שם פרטי',
            child: TextFormField(
              controller: familyContact3FirstName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם פרטי',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact3LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'שם משפחה',
            child: TextFormField(
              controller: familyContact3LastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן שם משפחה',
              ),
            ),
          ),
          InputFieldContainer(
            label: 'מספר טלפון',
            child: Column(
              children: [
                TextFormField(
                  controller: familyContact3Phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'empty';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'הזן מספר טלפון',
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Text(
                      'הזן ספרות בלבד',
                      style: TextStyles.s12w500cGray5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          InputFieldContainer(
            label: 'מייל',
            child: TextFormField(
              controller: familyContact3Email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'empty';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: 'הזן כתובת אימייל',
              ),
            ),
          ),
        ] else
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(FluentIcons.add_circle_24_regular),
                label: const Text('הוסף איש קשר חדש'),
                onPressed: () {
                  if (!familyShowContact2.value) {
                    familyShowContact2.value = true;
                    return;
                  } else if (!familyShowContact3.value) {
                    familyShowContact3.value = true;
                  }
                },
              ),
            ],
          ),
      ],
      ...[
        const Text(
          'לימודי תיכון',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'מוסד לימודים',
          child: TextFormField(
            controller: highSchoolName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן מוסד לימודים',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'ר”מ בתיכון',
          child: TextFormField(
            controller: highSchoolRoshMosadName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן את שם הר”מ בתיכון',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'טל’ ר”מ בתיכון',
          child: Column(
            children: [
              TextFormField(
                controller: highSchoolRoshMosadPhone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'empty';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'הזן את שם הר”מ בתיכון',
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Text(
                    'הזן מספרים בלבד, ללא רווחים',
                    style: TextStyles.s12w500cGray5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      ...[
        const Text(
          'עיסוק',
          style: TextStyles.s20w400cGrey2,
        ),
        InputFieldContainer(
          label: 'סטטוס',
          child: TextFormField(
            controller: workStatus,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן סטטוס',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'עיסוק',
          child: TextFormField(
            controller: workName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן עיסוק',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'מקום עבודה',
          child: TextFormField(
            controller: workPlace,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן מקום עבודה',
            ),
          ),
        ),
        InputFieldContainer(
          label: 'סוג עבודה',
          child: TextFormField(
            controller: workType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }

              return null;
            },
            decoration: const InputDecoration(
              hintText: 'הזן סוג עבודה',
            ),
          ),
        ),
      ],
    ];

    return Scaffold(
      appBar: const NewPersonaAppbar(title: 'הוספת חניך'),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: children.length,
                itemBuilder: (_, index) => children[index],
                separatorBuilder: (_, __) => const SizedBox(height: 24),
              ),
            ),
            AcceptCancelButtons(
              onPressedOk: () async {
                if (generalFirstName.text.isEmpty ||
                    generalLastName.text.isEmpty ||
                    generalTeudatZehut.text.isEmpty ||
                    generalPhone.text.isEmpty ||
                    generalRegion.value.isEmpty ||
                    generalCity.value.isEmpty ||
                    thInstitution.value.isEmpty ||
                    thPeriod.value.isEmpty ||
                    thMelave.value.isEmpty ||
                    thMatsbar.value.isEmpty ||
                    !(thIsPaying.value ?? false) ||
                    militaryArmyBase.value.isEmpty ||
                    militaryArmyServiceType.value.isEmpty ||
                    datesDateOfBirth.value == null) {
                  showMissingInfoDialog(context);
                }

                final navContext = Navigator.of(context);

                final result = await ref
                    .read(
                      usersControllerProvider.notifier,
                    )
                    .createManual(
                      persona: PersonaDto(
                        roles: [UserRole.apprentice],
                        firstName: generalFirstName.text,
                        lastName: generalLastName.text,
                        teudatZehut: generalTeudatZehut.text,
                        phone: generalPhone.text,
                        email: generalEmail.text,
                        address: AddressDto(
                          street: generalAddress.text,
                          region: generalRegion.value.name,
                          city: generalCity.value,
                        ),
                        maritalStatus: genrealMaritalStatus.value,
                        institutionId: thInstitution.value.id,
                        thPeriod: thPeriod.value,
                        thMentor: thMelave.value.id,
                        matsbarStatus: thMatsbar.value,
                        isPaying: thIsPaying.value!,
                        thRavMelamedYearAName: thRoshMosadYearAName.text,
                        thRavMelamedYearAPhone: thRoshMosadYearAPhone.text,
                        thRavMelamedYearBName: thRoshMosadYearBName.text,
                        thRavMelamedYearBPhone: thRoshMosadYearBPhone.text,
                        militaryCompoundId: militaryArmyBase.value.id,
                        militaryServiceType:
                            militaryArmyServiceType.value.hebrewName,
                        militaryPositionOld: militaryArmyPreviousRole.text,
                        militaryPositionNew: militaryArmyCurrentRole.text,
                        militaryDateOfEnlistment: militaryArmyEnlistmentDate
                                .value
                                ?.toIso8601String() ??
                            '',
                        militaryDateOfDischarge:
                            militaryArmyReleaseDate.value?.toIso8601String() ??
                                '',
                        dateOfBirth:
                            datesDateOfBirth.value?.toIso8601String() ?? '',
                        dateOfMarriage:
                            datesDateOfMarriage.value?.toIso8601String() ?? '',
                        contact1FirstName: familyContact1FirstName.text,
                        contact1LastName: familyContact1LastName.text,
                        contact1Phone: familyContact1Phone.text,
                        contact1Email: familyContact1Email.text,
                        contact2FirstName: familyContact2FirstName.text,
                        contact2LastName: familyContact2LastName.text,
                        contact2Phone: familyContact2Phone.text,
                        contact2Email: familyContact2Email.text,
                        contact3FirstName: familyContact3FirstName.text,
                        contact3LastName: familyContact3LastName.text,
                        contact3Phone: familyContact3Phone.text,
                        contact3Email: familyContact3Email.text,
                        highSchoolInstitution: highSchoolName.text,
                        highSchoolRavMelamedName: highSchoolRoshMosadName.text,
                        highSchoolRavMelamedPhone:
                            highSchoolRoshMosadPhone.text,
                        workStatus: workStatus.text,
                        workOccupation: workName.text,
                        workPlace: workPlace.text,
                        workType: workType.text,
                      ),
                    );

                if (result) {
                  // ignore: use_build_context_synchronously
                  const HomeRouteData().go(navContext.context);
                }
              },
              onPressedCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
