// ignore_for_file: unused_element

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/address_region.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/base/get_bases.dart';
import 'package:hadar_program/src/services/api/eshkol/get_eshkols.dart';
import 'package:hadar_program/src/services/api/hativa/get_hativot.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
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
  h,
}

enum _RamimYear {
  a,
  b,
  c,
  d,
  e,
  f,
}

enum _RoleInProgram {
  rakazMosad,
  rakazim,
  melavim,
  hanihim,
  roshMosad,
}

enum _StatusInProgram {
  married,
  single,
  inArmy,
  sadir,
  keva,
  released,
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
  }) : filterType = _FilterType.users;

  const FiltersScreen.institutions({
    super.key,
  }) : filterType = _FilterType.intitutions;

  const FiltersScreen.reports({
    super.key,
  }) : filterType = _FilterType.reports;

  const FiltersScreen.addRecipients({
    super.key,
  }) : filterType = _FilterType.reportGroup;

  // ignore: library_private_types_in_public_api
  final _FilterType filterType;

  @override
  Widget build(BuildContext context, ref) {
    final periodController = useTextEditingController();
    final compoundsController = useTextEditingController();
    final eshkolController = useTextEditingController();
    final hativaController = useTextEditingController();
    final citySearchController = useTextEditingController();
    final dateRange = useState<DateTimeRange?>(null);
    final selectedReportType = useState(<ReportEventType>[]);
    final selectedRole = useState(<_RoleInProgram>[]);
    final selectedYear = useState(<_YearInProgram>[]);
    final selectedStatus = useState(<_StatusInProgram>[]);
    final selectedCompounds = useState(<CompoundDto>[]);
    final selectedPeriods = useState(<String>[]);
    final selectedEshkols = useState(<String>[]);
    final selectedHativot = useState(<String>[]);
    final selectedRegion = useState(<AddressRegion>[]);
    final selectedCities = useState(<String>[]);
    final selectedRamim = useState(<_RamimYear>[]);
    final selectedRecipients = useState(<({String id, String name})>[]);

    final ramim = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.a),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.a)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.a,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.a,
              ],
        label: const Text('שנה א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.b),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.b)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.b,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.b,
              ],
        label: const Text('שנה ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.c),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.c)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.c,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.c,
              ],
        label: const Text('שנה ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.d),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.d)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.d,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.d,
              ],
        label: const Text('שנה ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.e),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.e)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.e,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.e,
              ],
        label: const Text('שנה ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value.contains(_RamimYear.f),
        onSelected: (val) => selectedRamim.value.contains(_RamimYear.f)
            ? selectedRamim.value = [
                ...selectedRamim.value.where(
                  (element) => element != _RamimYear.f,
                ),
              ]
            : selectedRamim.value = [
                ...selectedRamim.value,
                _RamimYear.f,
              ],
        label: const Text('שנה ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final years = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.a),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.a)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.a,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.a,
              ],
        label: const Text('א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.b),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.b)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.b,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.b,
              ],
        label: const Text('ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.c),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.c)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.c,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.c,
              ],
        label: const Text('ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.d),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.d)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.d,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.d,
              ],
        label: const Text('ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.e),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.e)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.e,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.e,
              ],
        label: const Text('ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.f),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.f)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.f,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.f,
              ],
        label: const Text('ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.g),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.g)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.g,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.g,
              ],
        label: const Text('ז'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value.contains(_YearInProgram.h),
        onSelected: (val) => selectedYear.value.contains(_YearInProgram.h)
            ? selectedYear.value = [
                ...selectedYear.value.where(
                  (element) => element != _YearInProgram.h,
                ),
              ]
            : selectedYear.value = [
                ...selectedYear.value,
                _YearInProgram.h,
              ],
        label: const Text('ח'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final roles = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value.contains(_RoleInProgram.rakazMosad),
        onSelected: (val) =>
            selectedRole.value.contains(_RoleInProgram.rakazMosad)
                ? selectedRole.value = [
                    ...selectedRole.value.where(
                      (element) => element != _RoleInProgram.rakazMosad,
                    ),
                  ]
                : selectedRole.value = [
                    ...selectedRole.value,
                    _RoleInProgram.rakazMosad,
                  ],
        label: const Text('רכזי מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value.contains(_RoleInProgram.rakazim),
        onSelected: (val) => selectedRole.value.contains(_RoleInProgram.rakazim)
            ? selectedRole.value = [
                ...selectedRole.value.where(
                  (element) => element != _RoleInProgram.rakazim,
                ),
              ]
            : selectedRole.value = [
                ...selectedRole.value,
                _RoleInProgram.rakazim,
              ],
        label: const Text('רכזים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value.contains(_RoleInProgram.melavim),
        onSelected: (val) => selectedRole.value.contains(_RoleInProgram.melavim)
            ? selectedRole.value = [
                ...selectedRole.value.where(
                  (element) => element != _RoleInProgram.melavim,
                ),
              ]
            : selectedRole.value = [
                ...selectedRole.value,
                _RoleInProgram.melavim,
              ],
        label: const Text('מלווים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value.contains(_RoleInProgram.hanihim),
        onSelected: (val) => selectedRole.value.contains(_RoleInProgram.hanihim)
            ? selectedRole.value = [
                ...selectedRole.value.where(
                  (element) => element != _RoleInProgram.hanihim,
                ),
              ]
            : selectedRole.value = [
                ...selectedRole.value,
                _RoleInProgram.hanihim,
              ],
        label: const Text('חניכים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value.contains(_RoleInProgram.roshMosad),
        onSelected: (val) =>
            selectedRole.value.contains(_RoleInProgram.roshMosad)
                ? selectedRole.value = [
                    ...selectedRole.value.where(
                      (element) => element != _RoleInProgram.roshMosad,
                    ),
                  ]
                : selectedRole.value = [
                    ...selectedRole.value,
                    _RoleInProgram.roshMosad,
                  ],
        label: const Text('ראש מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final statuses = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.married),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.married)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.married,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.married,
                  ],
        label: const Text('נשוי'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.single),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.single)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.single,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.single,
                  ],
        label: const Text('רווק'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.inArmy),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.inArmy)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.inArmy,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.inArmy,
                  ],
        label: const Text('בצבא'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.sadir),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.sadir)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.sadir,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.sadir,
                  ],
        label: const Text('סדיר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.keva),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.keva)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.keva,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.keva,
                  ],
        label: const Text('קבע'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value.contains(_StatusInProgram.released),
        onSelected: (val) =>
            selectedStatus.value.contains(_StatusInProgram.released)
                ? selectedStatus.value = [
                    ...selectedStatus.value.where(
                      (element) => element != _StatusInProgram.released,
                    ),
                  ]
                : selectedStatus.value = [
                    ...selectedStatus.value,
                    _StatusInProgram.released,
                  ],
        label: const Text('משוחרר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final reportTypes = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected:
            selectedReportType.value.contains(ReportEventType.failedAttempt),
        onSelected: (val) =>
            selectedReportType.value.contains(ReportEventType.failedAttempt)
                ? selectedReportType.value = [
                    ...selectedReportType.value.where(
                      (element) => element != ReportEventType.failedAttempt,
                    ),
                  ]
                : selectedReportType.value = [
                    ...selectedReportType.value,
                    ReportEventType.failedAttempt,
                  ],
        label: const Text('קשר שכשל'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected:
            selectedReportType.value.contains(ReportEventType.offlineMeeting),
        onSelected: (val) =>
            selectedReportType.value.contains(ReportEventType.offlineMeeting)
                ? selectedReportType.value = [
                    ...selectedReportType.value.where(
                      (element) => element != ReportEventType.offlineMeeting,
                    ),
                  ]
                : selectedReportType.value = [
                    ...selectedReportType.value,
                    ReportEventType.offlineMeeting,
                  ],
        label: const Text('מפגש'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected:
            selectedReportType.value.contains(ReportEventType.onlineMeeting),
        onSelected: (val) =>
            selectedReportType.value.contains(ReportEventType.onlineMeeting)
                ? selectedReportType.value = [
                    ...selectedReportType.value.where(
                      (element) => element != ReportEventType.onlineMeeting,
                    ),
                  ]
                : selectedReportType.value = [
                    ...selectedReportType.value,
                    ReportEventType.onlineMeeting,
                  ],
        label: const Text('זום'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedReportType.value.contains(ReportEventType.phoneCall),
        onSelected: (val) => selectedReportType.value
                .contains(ReportEventType.phoneCall)
            ? selectedReportType.value = [
                ...selectedReportType.value
                    .where((element) => element != ReportEventType.phoneCall),
              ]
            : selectedReportType.value = [
                ...selectedReportType.value,
                ReportEventType.phoneCall,
              ],
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
                                selected: selectedReportType.value
                                    .contains(ReportEventType.phoneCall),
                                onSelected: (val) => selectedReportType.value
                                        .contains(ReportEventType.phoneCall)
                                    ? selectedReportType.value
                                        .remove(ReportEventType.phoneCall)
                                    : selectedReportType.value
                                        .add(ReportEventType.phoneCall),
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
                          selectedPeriods: selectedPeriods,
                        ),
                      ),
                      if (filterType == _FilterType.users ||
                          filterType == _FilterType.reportGroup) ...[
                        const SizedBox(height: 24),
                        InputFieldContainer(
                          label: 'אשכול',
                          labelStyle: TextStyles.s16w400cGrey2,
                          child: ref.watch(getEshkolListProvider).when(
                                loading: () => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                error: (error, stack) => _EshkolWidget(
                                  eshkolController: eshkolController,
                                  selectedEshkols: selectedEshkols,
                                  eshkols: const [],
                                ),
                                data: (eshkolot) => _EshkolWidget(
                                  eshkolController: eshkolController,
                                  selectedEshkols: selectedEshkols,
                                  eshkols: eshkolot,
                                ),
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
                                selectedCompounds: selectedCompounds,
                                compounds: const [],
                              ),
                              data: (compounds) => _CompoundWidget(
                                compoundsController: compoundsController,
                                selectedCompounds: selectedCompounds,
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
                                selectedHativot: selectedHativot,
                                hativaController: hativaController,
                                hativot: const [],
                              ),
                              data: (hativot) => _HativotWidget(
                                selectedHativot: selectedHativot,
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
                          selectedRegion: selectedRegion,
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
                                selectedCities: selectedCities,
                                cities: const [],
                              ),
                              data: (citiesList) => _CityListWidget(
                                citySearchController: citySearchController,
                                selectedCities: selectedCities,
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
                      child: ref.watch(getApprenticesProvider).when(
                            loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                            error: (error, stack) => Center(
                              child: Text(error.toString()),
                            ),
                            data: (apprentices) => LargeFilledRoundedButton(
                              label: 'הבא',
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (val) {
                                      switch (filterType) {
                                        case _FilterType.users:
                                          return _SelectedUsersPage(
                                            items: apprentices
                                                .map(
                                                  (e) => (
                                                    id: e.id,
                                                    name: e.fullName
                                                  ),
                                                )
                                                .toList(),
                                            initiallySelected:
                                                selectedRecipients.value,
                                          );
                                        case _FilterType.reports:
                                        // const ReportsScreen();
                                        default:
                                          Toaster.unimplemented();
                                          return ErrorWidget.withDetails(
                                            message: 'unimplemented',
                                          );
                                      }
                                    },
                                  ),
                                );

                                if (result == null) {
                                  return;
                                }

                                selectedRecipients.value = [...result];
                              },
                            ),
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
    required this.selectedPeriods,
  });

  final TextEditingController periodController;
  final ValueNotifier<List<String>> selectedPeriods;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: Text(
          selectedPeriods.value.isEmpty
              ? 'בחירת בסיס'
              : selectedPeriods.value.join(', '),
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

          if (selectedPeriods.value.contains(value)) {
            selectedPeriods.value = [
              ...selectedPeriods.value.where((element) => element != value),
            ];
          } else {
            selectedPeriods.value = [
              ...selectedPeriods.value,
              value,
            ];
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
    required this.selectedEshkols,
    required this.eshkols,
  });

  final TextEditingController eshkolController;
  final ValueNotifier<List<String>> selectedEshkols;
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
            selectedEshkols.value.isEmpty
                ? 'בחירת בסיס'
                : selectedEshkols.value.join(', '),
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

          if (selectedEshkols.value.contains(value)) {
            selectedEshkols.value = [
              ...selectedEshkols.value.where((element) => element != value),
            ];
          } else {
            selectedEshkols.value = [
              ...selectedEshkols.value,
              value,
            ];
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
    required this.selectedCompounds,
    required this.compoundsController,
    required this.compounds,
  });

  final ValueNotifier<List<CompoundDto>> selectedCompounds;
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
            selectedCompounds.value.isEmpty
                ? 'בחירת בסיס'
                : selectedCompounds.value.map((e) => e.name).join(', '),
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

          if (selectedCompounds.value.contains(value)) {
            selectedCompounds.value = [
              ...selectedCompounds.value.where((element) => element != value),
            ];
          } else {
            selectedCompounds.value = [
              ...selectedCompounds.value,
              value,
            ];
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
    required this.selectedHativot,
    required this.hativaController,
    required this.hativot,
  });

  final ValueNotifier<List<String>> selectedHativot;
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
            selectedHativot.value.isEmpty
                ? 'בחירת חטיבה'
                : selectedHativot.value.map((e) => e).join(', '),
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

          if (selectedHativot.value.contains(value)) {
            selectedHativot.value = [
              ...selectedHativot.value.where((element) => element != value),
            ];
          } else {
            selectedHativot.value = [
              ...selectedHativot.value,
              value,
            ];
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
    required this.selectedRegion,
  });

  final ValueNotifier<List<AddressRegion>> selectedRegion;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            selectedRegion.value.isEmpty
                ? 'אזור מגורים'
                : selectedRegion.value.map((e) => e.name).join(', '),
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

          if (selectedRegion.value.contains(value)) {
            selectedRegion.value = [
              ...selectedRegion.value.where((element) => element != value),
            ];
          } else {
            selectedRegion.value = [
              ...selectedRegion.value,
              value,
            ];
          }
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
    required this.selectedCities,
    required this.citySearchController,
  });

  final List<String> cities;
  final ValueNotifier<List<String>> selectedCities;
  final TextEditingController citySearchController;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const Text('Error loading list');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: SizedBox(
          width: _kDropdownTextWidthLimit,
          child: Text(
            selectedCities.value.isEmpty
                ? 'יישוב / עיר'
                : selectedCities.value.join(', '),
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
          if (selectedCities.value.contains(value)) {
            selectedCities.value = [
              ...selectedCities.value.where((element) => element != value),
            ];
          } else {
            selectedCities.value = [
              ...selectedCities.value,
              value.toString(),
            ];
          }
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
                          title: const Text('name'),
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
