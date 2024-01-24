import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _YearInProgram {
  none,
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
  none,
  a,
  b,
  c,
  d,
  e,
  f,
}

enum _RoleInProgram {
  none,
  all,
  rakazMosad,
  rakazim,
  melavim,
  hanihim,
  roshMosad,
}

enum _StatusInProgram {
  none,
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

class FilterResultsPage extends HookConsumerWidget {
  const FilterResultsPage.users({
    super.key,
  }) : filterType = _FilterType.users;

  const FilterResultsPage.institutions({
    super.key,
  }) : filterType = _FilterType.intitutions;

  const FilterResultsPage.reports({
    super.key,
  }) : filterType = _FilterType.reports;

  const FilterResultsPage.reportGroup({
    super.key,
  }) : filterType = _FilterType.reportGroup;

  // ignore: library_private_types_in_public_api
  final _FilterType filterType;

  @override
  Widget build(BuildContext context, ref) {
    final selectedYear = useState(_YearInProgram.none);
    final selectedRole = useState(_RoleInProgram.none);
    final selectedStatus = useState(_StatusInProgram.none);
    final selectedRamim = useState(_RamimYear.none);
    final selectedReportType = useState(ReportEventType.none);
    final dateRange = useState<DateTimeRange?>(null);

    final ramim = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.a,
        onSelected: (val) => selectedRamim.value == _RamimYear.a
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.a,
        label: const Text('שנה א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.b,
        onSelected: (val) => selectedRamim.value == _RamimYear.b
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.b,
        label: const Text('שנה ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.c,
        onSelected: (val) => selectedRamim.value == _RamimYear.c
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.c,
        label: const Text('שנה ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.d,
        onSelected: (val) => selectedRamim.value == _RamimYear.d
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.d,
        label: const Text('שנה ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.e,
        onSelected: (val) => selectedRamim.value == _RamimYear.e
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.e,
        label: const Text('שנה ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRamim.value == _RamimYear.f,
        onSelected: (val) => selectedRamim.value == _RamimYear.f
            ? selectedRamim.value = _RamimYear.none
            : selectedRamim.value = _RamimYear.f,
        label: const Text('שנה ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final years = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.a,
        onSelected: (val) => selectedYear.value == _YearInProgram.a
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.a,
        label: const Text('א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.b,
        onSelected: (val) => selectedYear.value == _YearInProgram.b
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.b,
        label: const Text('ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.c,
        onSelected: (val) => selectedYear.value == _YearInProgram.c
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.c,
        label: const Text('ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.d,
        onSelected: (val) => selectedYear.value == _YearInProgram.d
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.d,
        label: const Text('ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.e,
        onSelected: (val) => selectedYear.value == _YearInProgram.e
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.e,
        label: const Text('ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.f,
        onSelected: (val) => selectedYear.value == _YearInProgram.f
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.f,
        label: const Text('ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.g,
        onSelected: (val) => selectedYear.value == _YearInProgram.g
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.g,
        label: const Text('ז'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == _YearInProgram.h,
        onSelected: (val) => selectedYear.value == _YearInProgram.h
            ? selectedYear.value = _YearInProgram.none
            : selectedYear.value = _YearInProgram.h,
        label: const Text('ח'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final roles = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.all,
        onSelected: (val) => selectedRole.value == _RoleInProgram.all
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.all,
        label: const Text('כולם'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.rakazMosad,
        onSelected: (val) => selectedRole.value == _RoleInProgram.rakazMosad
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.rakazMosad,
        label: const Text('רכזי מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.rakazim,
        onSelected: (val) => selectedRole.value == _RoleInProgram.rakazim
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.rakazim,
        label: const Text('רכזים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.melavim,
        onSelected: (val) => selectedRole.value == _RoleInProgram.melavim
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.melavim,
        label: const Text('מלווים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.hanihim,
        onSelected: (val) => selectedRole.value == _RoleInProgram.hanihim
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.hanihim,
        label: const Text('חניכים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == _RoleInProgram.roshMosad,
        onSelected: (val) => selectedRole.value == _RoleInProgram.roshMosad
            ? selectedRole.value = _RoleInProgram.none
            : selectedRole.value = _RoleInProgram.roshMosad,
        label: const Text('ראש מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final statuses = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.married,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.married
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.married,
        label: const Text('נשוי'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.single,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.single
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.single,
        label: const Text('רווק'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.inArmy,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.inArmy
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.inArmy,
        label: const Text('בצבא'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.sadir,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.sadir
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.sadir,
        label: const Text('סדיר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.keva,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.keva
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.keva,
        label: const Text('קבע'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == _StatusInProgram.released,
        onSelected: (val) => selectedStatus.value == _StatusInProgram.released
            ? selectedStatus.value = _StatusInProgram.none
            : selectedStatus.value = _StatusInProgram.released,
        label: const Text('משוחרר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final reportTypes = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedReportType.value == ReportEventType.failedAttempt,
        onSelected: (val) =>
            selectedReportType.value == ReportEventType.failedAttempt
                ? selectedReportType.value = ReportEventType.none
                : selectedReportType.value = ReportEventType.failedAttempt,
        label: const Text('קשר שכשל'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedReportType.value == ReportEventType.offlineMeeting,
        onSelected: (val) =>
            selectedReportType.value == ReportEventType.offlineMeeting
                ? selectedReportType.value = ReportEventType.none
                : selectedReportType.value = ReportEventType.offlineMeeting,
        label: const Text('מפגש'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedReportType.value == ReportEventType.onlineMeeting,
        onSelected: (val) =>
            selectedReportType.value == ReportEventType.onlineMeeting
                ? selectedReportType.value = ReportEventType.none
                : selectedReportType.value = ReportEventType.onlineMeeting,
        label: const Text('זום'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedReportType.value == ReportEventType.phoneCall,
        onSelected: (val) =>
            selectedReportType.value == ReportEventType.phoneCall
                ? selectedReportType.value = ReportEventType.none
                : selectedReportType.value = ReportEventType.phoneCall,
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
                            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
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
                          selected: selectedReportType.value ==
                              ReportEventType.phoneCall,
                          onSelected: (val) => selectedReportType.value ==
                                  ReportEventType.phoneCall
                              ? selectedReportType.value = ReportEventType.none
                              : selectedReportType.value =
                                  ReportEventType.phoneCall,
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
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
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
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
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
                        items: const [],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'מחזור בישיבה / מכינה',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת מחזור'),
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
                      onChanged: (value) {},
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
                      items: const [],
                    ),
                  ),
                ),
                if (filterType == _FilterType.users ||
                    filterType == _FilterType.reportGroup) ...[
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'אשכול',
                    labelStyle: TextStyles.s16w400cGrey2,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: '',
                        hint: const Text('בחירת אשכול'),
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
                        onChanged: (value) {},
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
                        items: const [],
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
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'בסיס',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת בסיס'),
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
                      onChanged: (value) {},
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
                      items: const [],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'חטיבה',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת חטיבה'),
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
                      onChanged: (value) {},
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
                      items: const [],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'אזור מגורים',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת אזור מגורים'),
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
                      onChanged: (value) {},
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
                      items: const [],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldContainer(
                  label: 'יישוב /עיר מגורים',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת יישוב/ עיר'),
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
                      onChanged: (value) {},
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
                      items: const [],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'הבא',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (val) {
                              return const _SelectedUsersPage();
                            },
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedUsersPage extends StatelessWidget {
  const _SelectedUsersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              const ColoredBox(
                color: Colors.white,
                child: Text(
                  'סה”כ 127',
                  style: TextStyles.s14w300cGray5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: List.generate(
                    33,
                    (index) => CheckboxListTile(
                      value: Random().nextBool(),
                      title: const Text('name'),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppColors.blue03;
                        }

                        return null;
                      }),
                      onChanged: (val) => Toaster.unimplemented(),
                    ),
                  ),
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
                            onPressed: () => Toaster.unimplemented(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LargeFilledRoundedButton.cancel(
                            label: 'הקודם',
                            onPressed: () => Toaster.unimplemented(),
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
