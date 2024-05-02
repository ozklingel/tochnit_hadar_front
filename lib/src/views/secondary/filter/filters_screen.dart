// ignore_for_file: unused_element

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/address_region.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/base/get_bases.dart';
import 'package:hadar_program/src/services/api/eshkol/get_eshkols.dart';
import 'package:hadar_program/src/services/api/hativa/get_hativot.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kDropdownTextWidthLimit = 260.0;

enum _YearInProgram {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h;

  String get name {
    switch (this) {
      case a:
        return 'א';
      case b:
        return 'ב';
      case c:
        return 'ג';
      case d:
        return 'ד';
      case e:
        return 'ה';
      case f:
        return 'ו';
      case g:
        return 'ז';
      case h:
        return 'ח';
    }
  }
}

enum _RamimYear {
  a,
  b,
  c,
  d,
  e,
  f;

  String get name {
    switch (this) {
      case a:
        return 'א';
      case b:
        return 'ב';
      case c:
        return 'ג';
      case d:
        return 'ד';
      case e:
        return 'ה';
      case f:
        return 'ו';
    }
  }
}

enum _RoleInProgram {
  rakazMosad,
  melavim,
  hanihim,
  roshMosad;

  String get name {
    switch (this) {
      case rakazMosad:
        return 'רכזי אשכול';
      case melavim:
        return 'מלוים';
      case hanihim:
        return 'חניכים';
      case roshMosad:
        return 'רכזי מוסד';
    }
  }
}

enum _StatusInProgram {
  married,
  single,
  inArmy,
  sadir,
  keva,
  released;

  String get name {
    switch (this) {
      case married:
        return 'נשוי';
      case single:
        return 'רווק';
      case inArmy:
        return 'בצבא';
      case sadir:
        return 'סדיר';
      case keva:
        return 'קבע';
      case released:
        return 'משוחרר';
    }
  }
}

enum _FilterType {
  users,
  intitutions,
  reports,
  reportGroup,
}

class FiltersScreen extends HookConsumerWidget {
  const FiltersScreen.users({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.users;

  const FiltersScreen.institutionUsers({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.intitutions;

  const FiltersScreen.reports({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.reports;

  const FiltersScreen.addRecipients({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.reportGroup;

  // ignore: library_private_types_in_public_api
  final _FilterType filterType;

  final FilterDto initFilters;

  @override
  Widget build(BuildContext context, ref) {
    final eshkols = ref.watch(getEshkolListProvider).valueOrNull ?? [];
    final filter = useState(initFilters);
    final periodController = useTextEditingController();
    final compoundsController = useTextEditingController();
    final eshkolController = useTextEditingController();
    final hativaController = useTextEditingController();
    final citySearchController = useTextEditingController();
    final dateRange = useState<DateTimeRange?>(null);

    final ramim = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.a.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.a.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.a.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.a.name,
                ],
        ),
        label: Text(_RamimYear.a.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.b.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.b.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.b.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.b.name,
                ],
        ),
        label: Text(_RamimYear.b.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.c.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.c.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.c.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.c.name,
                ],
        ),
        label: Text(_RamimYear.c.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.d.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.d.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.d.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.d.name,
                ],
        ),
        label: Text(_RamimYear.d.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.e.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.e.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.e.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.e.name,
                ],
        ),
        label: Text(_RamimYear.e.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.ramim.contains(_RamimYear.f.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          ramim: filter.value.ramim.contains(_RamimYear.f.name)
              ? [
                  ...filter.value.ramim.where(
                    (element) => element != _RamimYear.f.name,
                  ),
                ]
              : [
                  ...filter.value.ramim,
                  _RamimYear.f.name,
                ],
        ),
        label: Text(_RamimYear.f.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final years = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.a.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.a.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.a.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.a.name,
                ],
        ),
        label: Text(_YearInProgram.a.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.b.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.b.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.b.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.b.name,
                ],
        ),
        label: Text(_YearInProgram.b.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.c.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.c.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.c.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.c.name,
                ],
        ),
        label: Text(_YearInProgram.c.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.d.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.d.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.d.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.d.name,
                ],
        ),
        label: Text(_YearInProgram.d.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.e.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.e.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.e.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.e.name,
                ],
        ),
        label: Text(_YearInProgram.e.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.f.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.f.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.f.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.f.name,
                ],
        ),
        label: Text(_YearInProgram.f.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.g.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.g.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.g.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.g.name,
                ],
        ),
        label: Text(_YearInProgram.g.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.years.contains(_YearInProgram.h.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          years: filter.value.years.contains(_YearInProgram.h.name)
              ? [
                  ...filter.value.years.where(
                    (element) => element != _YearInProgram.h.name,
                  ),
                ]
              : [
                  ...filter.value.years,
                  _YearInProgram.h.name,
                ],
        ),
        label: Text(_YearInProgram.h.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final roles = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.roles.contains(_RoleInProgram.rakazMosad.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          roles: filter.value.roles.contains(_RoleInProgram.rakazMosad.name)
              ? [
                  ...filter.value.roles.where(
                    (element) => element != _RoleInProgram.rakazMosad.name,
                  ),
                ]
              : [
                  ...filter.value.roles,
                  _RoleInProgram.rakazMosad.name,
                ],
        ),
        label: Text(_RoleInProgram.rakazMosad.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.roles.contains(_RoleInProgram.melavim.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          roles: filter.value.roles.contains(_RoleInProgram.melavim.name)
              ? [
                  ...filter.value.roles.where(
                    (element) => element != _RoleInProgram.melavim.name,
                  ),
                ]
              : [
                  ...filter.value.roles,
                  _RoleInProgram.melavim.name,
                ],
        ),
        label: Text(_RoleInProgram.melavim.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.roles.contains(_RoleInProgram.hanihim.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          roles: filter.value.roles.contains(_RoleInProgram.hanihim.name)
              ? [
                  ...filter.value.roles.where(
                    (element) => element != _RoleInProgram.hanihim.name,
                  ),
                ]
              : [
                  ...filter.value.roles,
                  _RoleInProgram.hanihim.name,
                ],
        ),
        label: Text(_RoleInProgram.hanihim.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.roles.contains(_RoleInProgram.roshMosad.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          roles: filter.value.roles.contains(_RoleInProgram.roshMosad.name)
              ? [
                  ...filter.value.roles.where(
                    (element) => element != _RoleInProgram.roshMosad.name,
                  ),
                ]
              : [
                  ...filter.value.roles,
                  _RoleInProgram.roshMosad.name,
                ],
        ),
        label: Text(_RoleInProgram.roshMosad.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final statuses = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.statuses.contains(_StatusInProgram.married.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses:
              filter.value.statuses.contains(_StatusInProgram.married.name)
                  ? [
                      ...filter.value.statuses.where(
                        (element) => element != _StatusInProgram.married.name,
                      ),
                    ]
                  : [
                      ...filter.value.statuses,
                      _StatusInProgram.married.name,
                    ],
        ),
        label: Text(_StatusInProgram.married.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.statuses.contains(_StatusInProgram.single.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses: filter.value.statuses.contains(_StatusInProgram.single.name)
              ? [
                  ...filter.value.statuses.where(
                    (element) => element != _StatusInProgram.single.name,
                  ),
                ]
              : [
                  ...filter.value.statuses,
                  _StatusInProgram.single.name,
                ],
        ),
        label: Text(_StatusInProgram.single.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.statuses.contains(_StatusInProgram.inArmy.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses: filter.value.statuses.contains(_StatusInProgram.inArmy.name)
              ? [
                  ...filter.value.statuses.where(
                    (element) => element != _StatusInProgram.inArmy.name,
                  ),
                ]
              : [
                  ...filter.value.statuses,
                  _StatusInProgram.inArmy.name,
                ],
        ),
        label: Text(_StatusInProgram.inArmy.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.statuses.contains(_StatusInProgram.sadir.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses: filter.value.statuses.contains(_StatusInProgram.sadir.name)
              ? [
                  ...filter.value.statuses.where(
                    (element) => element != _StatusInProgram.sadir.name,
                  ),
                ]
              : [
                  ...filter.value.statuses,
                  _StatusInProgram.sadir.name,
                ],
        ),
        label: const Text('סדיר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.statuses.contains(_StatusInProgram.keva.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses: filter.value.statuses.contains(_StatusInProgram.keva.name)
              ? [
                  ...filter.value.statuses.where(
                    (element) => element != _StatusInProgram.keva.name,
                  ),
                ]
              : [
                  ...filter.value.statuses,
                  _StatusInProgram.keva.name,
                ],
        ),
        label: Text(_StatusInProgram.keva.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected:
            filter.value.statuses.contains(_StatusInProgram.released.name),
        onSelected: (val) => filter.value = filter.value.copyWith(
          statuses:
              filter.value.statuses.contains(_StatusInProgram.released.name)
                  ? [
                      ...filter.value.statuses.where(
                        (element) => element != _StatusInProgram.released.name,
                      ),
                    ]
                  : [
                      ...filter.value.statuses,
                      _StatusInProgram.released.name,
                    ],
        ),
        label: Text(_StatusInProgram.released.name),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final reportTypes = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.reportEventTypes.contains(Event.failedAttempt),
        onSelected: (val) => filter.value = filter.value.copyWith(
          reportEventTypes:
              filter.value.reportEventTypes.contains(Event.failedAttempt)
                  ? [
                      ...filter.value.reportEventTypes.where(
                        (element) => element != Event.failedAttempt,
                      ),
                    ]
                  : [
                      ...filter.value.reportEventTypes,
                      Event.failedAttempt,
                    ],
        ),
        label: const Text('קשר שכשל'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.reportEventTypes.contains(Event.offlineMeeting),
        onSelected: (val) => filter.value = filter.value.copyWith(
          reportEventTypes:
              filter.value.reportEventTypes.contains(Event.offlineMeeting)
                  ? [
                      ...filter.value.reportEventTypes.where(
                        (element) => element != Event.offlineMeeting,
                      ),
                    ]
                  : [
                      ...filter.value.reportEventTypes,
                      Event.offlineMeeting,
                    ],
        ),
        label: const Text('מפגש'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.reportEventTypes.contains(Event.onlineMeeting),
        onSelected: (val) => filter.value = filter.value.copyWith(
          reportEventTypes:
              filter.value.reportEventTypes.contains(Event.onlineMeeting)
                  ? [
                      ...filter.value.reportEventTypes.where(
                        (element) => element != Event.onlineMeeting,
                      ),
                    ]
                  : [
                      ...filter.value.reportEventTypes,
                      Event.onlineMeeting,
                    ],
        ),
        label: const Text('זום'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: filter.value.reportEventTypes.contains(Event.call),
        onSelected: (val) => filter.value = filter.value.copyWith(
          reportEventTypes: filter.value.reportEventTypes.contains(Event.call)
              ? [
                  ...filter.value.reportEventTypes.where(
                    (element) => element != Event.call,
                  ),
                ]
              : [
                  ...filter.value.reportEventTypes,
                  Event.call,
                ],
        ),
        label: const Text('שיחה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            filterType == _FilterType.users
                ? 'הוספת קבוצת נמענים'
                : filterType == _FilterType.intitutions
                    ? 'סנן משתמשים לפי'
                    : filterType == _FilterType.reports
                        ? 'הצג דיווחים לפי'
                        : filterType == _FilterType.reportGroup
                            ? 'הוספת קבוצת משתתפים'
                            : 'error',
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (filterType == _FilterType.reports) ...[
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final result = await showDateRangePicker(
                                  context: context,
                                  firstDate:
                                      DateTime.fromMillisecondsSinceEpoch(0),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 10)),
                                );

                                dateRange.value = result;
                              },
                              icon: const Icon(FluentIcons.calendar_24_regular),
                              label: const Text('בחירת טווח תאריכים'),
                            ),
                          ],
                        ),
                        if (dateRange.value != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ChoiceChip(
                                showCheckmark: false,
                                selectedColor: AppColors.blue06,
                                color: MaterialStateColor.resolveWith(
                                  (states) => AppColors.blue06,
                                ),
                                selected: filter.value.reportEventTypes
                                    .contains(Event.call),
                                onSelected: (val) =>
                                    filter.value = filter.value.copyWith(
                                  reportEventTypes: filter
                                          .value.reportEventTypes
                                          .contains(Event.call)
                                      ? [
                                          ...filter.value.reportEventTypes
                                              .where(
                                            (element) => element != Event.call,
                                          ),
                                        ]
                                      : [
                                          ...filter.value.reportEventTypes,
                                          Event.call,
                                        ],
                                ),
                                label: Row(
                                  children: [
                                    Text(
                                      '${dateRange.value!.start.asDayMonthYearShortDot}'
                                      ' - '
                                      '${dateRange.value!.end.asDayMonthYearShortDot}',
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.close,
                                      color: AppColors.blue02,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                labelStyle: TextStyles.s14w400cBlue2,
                                side: const BorderSide(color: AppColors.blue06),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        InputFieldContainer(
                          label: 'סוג דיווח',
                          labelStyle: TextStyles.s16w400cGrey2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: reportTypes.length,
                              itemBuilder: (ctx, idx) => reportTypes[idx],
                              separatorBuilder: (ctx, idx) =>
                                  const SizedBox(width: 8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      InputFieldContainer(
                        label: 'תפקיד',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: roles.length,
                            itemBuilder: (ctx, idx) => roles[idx],
                            separatorBuilder: (ctx, idx) =>
                                const SizedBox(width: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'שנה בתוכנית',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: years.length,
                            itemBuilder: (ctx, idx) => years[idx],
                            separatorBuilder: (ctx, idx) =>
                                const SizedBox(width: 8),
                          ),
                        ),
                      ),
                      if (filterType == _FilterType.reportGroup) ...[
                        const SizedBox(height: 24),
                        InputFieldContainer(
                          label: 'ר”מים',
                          labelStyle: TextStyles.s16w400cGrey2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: ramim.length,
                              itemBuilder: (ctx, idx) => ramim[idx],
                              separatorBuilder: (ctx, idx) =>
                                  const SizedBox(width: 8),
                            ),
                          ),
                        ),
                      ],
                      if (filterType == _FilterType.users ||
                          filterType == _FilterType.reportGroup) ...[
                        const SizedBox(height: 24),
                        InputFieldContainer(
                          label: 'שם מוסד',
                          labelStyle: TextStyles.s16w400cGrey2,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              value: '',
                              hint: const Text('בחירת מוסד'),
                              style: TextStyles.s16w400cGrey5,
                              selectedItemBuilder: (context) {
                                return [];
                              },
                              onMenuStateChange: (isOpen) {},
                              dropdownSearchData: const DropdownSearchData(
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'חיפוש',
                                    hintStyle: TextStyles.s14w400,
                                  ),
                                ),
                              ),
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36),
                                  border: Border.all(
                                    color: AppColors.shades300,
                                  ),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.only(right: 8),
                              ),
                              onChanged: (value) {},
                              dropdownStyleData: const DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: AppColors.grey6,
                                    ),
                                  ),
                                ),
                                openMenuIcon: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: AppColors.grey6,
                                    ),
                                  ),
                                ),
                              ),
                              items: const [],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'מחזור בישיבה / מכינה',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: _MahzorWidget(
                          periodController: periodController,
                          filter: filter,
                        ),
                      ),
                      if (filterType == _FilterType.users ||
                          filterType == _FilterType.reportGroup) ...[
                        const SizedBox(height: 24),
                        InputFieldContainer(
                          label: 'אשכול',
                          labelStyle: TextStyles.s16w400cGrey2,
                          child: _EshkolWidget(
                            eshkolController: eshkolController,
                            filter: filter,
                            eshkols: eshkols,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'סטטוס',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: statuses.length,
                            itemBuilder: (ctx, idx) => statuses[idx],
                            separatorBuilder: (ctx, idx) =>
                                const SizedBox(width: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'בסיס',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: ref.watch(getCompoundListProvider).when(
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              error: (error, stack) => _CompoundWidget(
                                compoundsController: compoundsController,
                                filters: filter,
                                compounds: const [],
                              ),
                              data: (compounds) => _CompoundWidget(
                                compoundsController: compoundsController,
                                filters: filter,
                                compounds: compounds,
                              ),
                            ),
                      ),
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'חטיבה',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: ref.watch(getHativotListProvider).when(
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              error: (error, stack) => _HativotWidget(
                                filter: filter,
                                hativaController: hativaController,
                                hativot: const [],
                              ),
                              data: (hativot) => _HativotWidget(
                                filter: filter,
                                hativaController: hativaController,
                                hativot: hativot,
                              ),
                            ),
                      ),
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'אזור מגורים',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: _RegionWidget(
                          filter: filter,
                        ),
                      ),
                      const SizedBox(height: 24),
                      InputFieldContainer(
                        label: 'יישוב /עיר מגורים',
                        labelStyle: TextStyles.s16w400cGrey2,
                        child: ref.watch(getCitiesListProvider).when(
                              loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              error: (error, stack) => _CityListWidget(
                                citySearchController: citySearchController,
                                filter: filter,
                                cities: const [],
                              ),
                              data: (citiesList) => _CityListWidget(
                                citySearchController: citySearchController,
                                filter: filter,
                                cities: citiesList,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'הבא',
                        onPressed: () =>
                            Navigator.of(context).pop(filter.value),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: LargeFilledRoundedButton.cancel(
                        label: 'ביטול',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MahzorWidget extends StatelessWidget {
  const _MahzorWidget({
    super.key,
    required this.periodController,
    required this.filter,
  });

  final TextEditingController periodController;
  final ValueNotifier<FilterDto> filter;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: Text(
          filter.value.periods.isEmpty
              ? 'בחירת בסיס'
              : filter.value.periods.join(', '),
        ),
        selectedItemBuilder: (context) {
          return [];
        },
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            periodController.clear();
          }
        },
        dropdownSearchData: DropdownSearchData(
          searchController: periodController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: TextField(
            controller: periodController,
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
                .contains(searchValue.toLowerCase().trim());
          },
        ),
        style: TextStyles.s16w400cGrey5,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shades300,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: (value) {
          if (value == null) {
            return;
          }

          if (filter.value.periods.contains(value)) {
            filter.value = filter.value.copyWith(
              periods: [
                ...filter.value.periods.where((element) => element != value),
              ],
            );
          } else {
            filter.value = filter.value.copyWith(
              periods: [
                ...filter.value.periods,
                value,
              ],
            );
          }
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: [
          'א',
          'ב',
          'ג',
          'ד',
          'ה',
          'ו',
          'ז',
          'ח',
          'ט',
          'י',
          'כ',
          'ל',
          'מ',
          'נ',
        ]
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EshkolWidget extends StatelessWidget {
  const _EshkolWidget({
    super.key,
    required this.eshkolController,
    required this.filter,
    required this.eshkols,
  });

  final ValueNotifier<FilterDto> filter;
  final TextEditingController eshkolController;
  final List<String> eshkols;

  @override
  Widget build(BuildContext context) {
    if (eshkols.isEmpty) {
      return const Text('Error loading list');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            filter.value.eshkols.isEmpty
                ? 'בחירת בסיס'
                : filter.value.eshkols.join(', '),
          ),
        ),
        selectedItemBuilder: (context) {
          return [];
        },
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            eshkolController.clear();
          }
        },
        dropdownSearchData: DropdownSearchData(
          searchController: eshkolController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: TextField(
            controller: eshkolController,
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
                .contains(searchValue.toLowerCase().trim());
          },
        ),
        style: TextStyles.s16w400cGrey5,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shades300,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: (value) {
          if (value == null) {
            return;
          }

          filter.value = filter.value.copyWith(
            eshkols: filter.value.eshkols.contains(value)
                ? [
                    ...filter.value.eshkols
                        .where((element) => element != value),
                  ]
                : [
                    ...filter.value.eshkols,
                    value,
                  ],
          );
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: eshkols
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CompoundWidget extends StatelessWidget {
  const _CompoundWidget({
    super.key,
    required this.filters,
    required this.compoundsController,
    required this.compounds,
  });

  final ValueNotifier<FilterDto> filters;
  final TextEditingController compoundsController;
  final List<CompoundDto> compounds;

  @override
  Widget build(BuildContext context) {
    if (compounds.isEmpty) {
      return const Text('Error loading list');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<CompoundDto>(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            filters.value.isEmpty
                ? 'בחירת בסיס'
                : filters.value.bases.join(', '),
          ),
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            compoundsController.clear();
          }
        },
        dropdownSearchData: DropdownSearchData(
          searchController: compoundsController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: TextField(
            controller: compoundsController,
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
                .contains(searchValue.toLowerCase().trim());
          },
        ),
        style: TextStyles.s16w400cGrey5,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shades300,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: (value) {
          if (value == null) {
            return;
          }

          filters.value = filters.value.copyWith(
            bases: filters.value.bases.contains(value)
                ? [
                    ...filters.value.bases
                        .where((element) => element != value.name),
                  ]
                : [
                    ...filters.value.bases,
                    value.name,
                  ],
          );
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: compounds
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HativotWidget extends StatelessWidget {
  const _HativotWidget({
    super.key,
    required this.filter,
    required this.hativaController,
    required this.hativot,
  });

  final ValueNotifier<FilterDto> filter;
  final TextEditingController hativaController;
  final List<String> hativot;

  @override
  Widget build(BuildContext context) {
    if (hativot.isEmpty) {
      return const Text('Error loading list');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            filter.value.hativot.isEmpty
                ? 'בחירת חטיבה'
                : filter.value.hativot.map((e) => e).join(', '),
          ),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: hativaController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: TextField(
            controller: hativaController,
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
                .contains(searchValue.toLowerCase().trim());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            hativaController.clear();
          }
        },
        style: TextStyles.s16w400cGrey5,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shades300,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: (value) {
          if (value == null) {
            return;
          }

          filter.value = filter.value.copyWith(
            hativot: filter.value.hativot.contains(value)
                ? [
                    ...filter.value.hativot
                        .where((element) => element != value),
                  ]
                : [
                    ...filter.value.hativot,
                    value,
                  ],
          );
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: hativot
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RegionWidget extends StatelessWidget {
  const _RegionWidget({
    super.key,
    required this.filter,
  });

  final ValueNotifier<FilterDto> filter;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<AddressRegion>(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            filter.value.regions.isEmpty
                ? 'אזור מגורים'
                : filter.value.regions.join(', '),
          ),
        ),
        style: Theme.of(context).inputDecorationTheme.hintStyle,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shade04,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: (value) {
          if (value == null) {
            return;
          }

          filter.value = filter.value.copyWith(
            regions: filter.value.regions.contains(value.name)
                ? [
                    ...filter.value.regions
                        .where((element) => element != value.name),
                  ]
                : [
                    ...filter.value.regions,
                    value.name,
                  ],
          );
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: [
          DropdownMenuItem(
            value: AddressRegion.center,
            child: Text(AddressRegion.center.name),
          ),
          DropdownMenuItem(
            value: AddressRegion.jerusalem,
            child: Text(AddressRegion.jerusalem.name),
          ),
          DropdownMenuItem(
            value: AddressRegion.north,
            child: Text(AddressRegion.north.name),
          ),
          DropdownMenuItem(
            value: AddressRegion.south,
            child: Text(AddressRegion.south.name),
          ),
          DropdownMenuItem(
            value: AddressRegion.yehuda,
            child: Text(AddressRegion.yehuda.name),
          ),
        ],
      ),
    );
  }
}

class _CityListWidget extends StatelessWidget {
  const _CityListWidget({
    super.key,
    required this.cities,
    required this.filter,
    required this.citySearchController,
  });

  final List<String> cities;
  final ValueNotifier<FilterDto> filter;
  final TextEditingController citySearchController;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const Text('Error loading list');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            filter.value.cities.isEmpty
                ? 'יישוב / עיר'
                : filter.value.cities.join(', '),
            overflow: TextOverflow.fade,
          ),
        ),
        style: Theme.of(context).inputDecorationTheme.hintStyle,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: AppColors.shade04),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
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
                .contains(searchValue.toLowerCase().trim());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            citySearchController.clear();
          }
        },
        onChanged: (value) {
          filter.value = filter.value.copyWith(
            cities: filter.value.cities.contains(value)
                ? [
                    ...filter.value.cities.where((element) => element != value),
                  ]
                : [
                    ...filter.value.cities,
                    value.toString(),
                  ],
          );
        },
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.chevron_left,
                color: AppColors.grey6,
              ),
            ),
          ),
        ),
        items: cities
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SelectedUsersPage extends HookWidget {
  const _SelectedUsersPage({
    super.key,
    required this.items,
    required this.initiallySelected,
  });

  final List<({String id, String name})> items;
  final List<({String id, String name})> initiallySelected;

  @override
  Widget build(BuildContext context) {
    final selected = useState(initiallySelected);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('נמענים שנבחרו'),
          actions: const [
            CloseButton(),
            SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: Colors.white,
                child: Text(
                  'סה”כ ${items.length}',
                  style: TextStyles.s14w300cGray5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: items
                      .map(
                        (e) => CheckboxListTile(
                          value: selected.value.contains(e),
                          title: Text(e.name),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return AppColors.blue03;
                            }

                            return null;
                          }),
                          onChanged: (val) {
                            if (selected.value.contains(e)) {
                              selected.value = [
                                ...selected.value
                                    .where((element) => element.id != e.id),
                              ];
                            } else {
                              selected.value = [
                                ...selected.value,
                                e,
                              ];
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: LargeFilledRoundedButton(
                            label: 'אישור',
                            onPressed: () =>
                                Navigator.of(context).pop(selected.value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LargeFilledRoundedButton.cancel(
                            label: 'הקודם',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
