// ignore_for_file: unused_element

import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/enums/address_region.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/core/utils/extensions/string.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/base/get_bases.dart';
import 'package:hadar_program/src/services/api/eshkol/get_eshkols.dart';
import 'package:hadar_program/src/services/api/hativa/get_hativot.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/onboarding_form/city_list.dart';
import 'package:hadar_program/src/views/widgets/buttons/general_dropdown_button.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kDropdownTextWidthLimit = 260.0;

String _engToHebLetter(String letter) => String.fromCharCode(
      ('א'.codeUnitAt(0)) + letter.codeUnitAt(0) - 'a'.codeUnitAt(0),
    );

enum _YearInProgram {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h;

  String get name => _engToHebLetter(toString().split('.').last);
}

enum _RamimYear {
  a,
  b,
  c,
  d,
  e,
  f;

  String get name => _engToHebLetter(toString().split('.').last);
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
  institutions,
  reports,
  reportGroup;

  String get actionLabel => switch (this) {
        users => 'הוספת קבוצת נמענים',
        institutions => 'סנן משתמשים לפי',
        reports => 'הצג דיווחים לפי',
        reportGroup => 'הוספת קבוצת משתתפים',
      };
}

class FiltersScreen extends HookConsumerWidget {
  const FiltersScreen.users({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.users;

  const FiltersScreen.institutionUsers({
    super.key,
    required this.initFilters,
  }) : filterType = _FilterType.institutions;

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
    final thInstitutionSearch = useTextEditingController();
    final institutionController = useState(const InstitutionDto());

    final ramim = _RamimYear.values
        .map(
          (ramimYear) => ChoiceChip(
            showCheckmark: false,
            selectedColor: AppColors.blue06,
            selected: filter.value.ramim.contains(ramimYear.name),
            onSelected: (val) => filter.value = filter.value.copyWith(
              ramim: filter.value.ramim.contains(ramimYear.name)
                  ? [
                      ...filter.value.ramim.where(
                        (element) => element != ramimYear.name,
                      ),
                    ]
                  : [
                      ...filter.value.ramim,
                      ramimYear.name,
                    ],
            ),
            label: Text(ramimYear.name),
            labelStyle: TextStyles.s14w400cBlue2,
            side: const BorderSide(color: AppColors.blue06),
          ),
        )
        .toList();

    final years = _YearInProgram.values
        .map(
          (year) => ChoiceChip(
            showCheckmark: false,
            selectedColor: AppColors.blue06,
            selected: filter.value.years.contains(year.name),
            onSelected: (val) => filter.value = filter.value.copyWith(
              years: filter.value.years.contains(year.name)
                  ? [
                      ...filter.value.years.where(
                        (element) => element != year.name,
                      ),
                    ]
                  : [
                      ...filter.value.years,
                      year.name,
                    ],
            ),
            label: Text(year.name),
            labelStyle: TextStyles.s14w400cBlue2,
            side: const BorderSide(color: AppColors.blue06),
          ),
        )
        .toList();

    final roles = UserRole.values
        .whereNot((element) => element == UserRole.unknown)
        .map(
          (role) => ChoiceChip(
            showCheckmark: false,
            selectedColor: AppColors.blue06,
            selected: filter.value.roles.contains(role.name),
            onSelected: (val) => filter.value = filter.value.copyWith(
              roles: filter.value.roles.contains(role.name)
                  ? [
                      ...filter.value.roles.where(
                        (element) => element != role.name,
                      ),
                    ]
                  : [
                      ...filter.value.roles,
                      role.name,
                    ],
            ),
            label: Text(role.name),
            labelStyle: TextStyles.s14w400cBlue2,
            side: const BorderSide(color: AppColors.blue06),
          ),
        )
        .toList();

    final statuses = _StatusInProgram.values
        .map(
          (status) => ChoiceChip(
            showCheckmark: false,
            selectedColor: AppColors.blue06,
            selected: filter.value.statuses.contains(status.name),
            onSelected: (val) => filter.value = filter.value.copyWith(
              statuses: filter.value.statuses.contains(status.name)
                  ? [
                      ...filter.value.statuses.where(
                        (element) => element != status.name,
                      ),
                    ]
                  : [
                      ...filter.value.statuses,
                      status.name,
                    ],
            ),
            label: Text(status.name),
            labelStyle: TextStyles.s14w400cBlue2,
            side: const BorderSide(color: AppColors.blue06),
          ),
        )
        .toList();

    String reportLabel(Event event) => switch (event) {
          Event.failedAttempt => 'ניסיון שכשל',
          Event.meeting => 'מפגש',
          Event.onlineMeeting => 'זום',
          Event.call => 'שיחה',
          _ => throw 'Unknown event type',
        };

    final reportTypes = [
      Event.failedAttempt,
      Event.meeting,
      Event.onlineMeeting,
      Event.call,
    ]
        .map(
          (event) => ChoiceChip(
            showCheckmark: false,
            selectedColor: AppColors.blue06,
            selected: filter.value.reportEventTypes.contains(event),
            onSelected: (val) => filter.value = filter.value.copyWith(
              reportEventTypes: filter.value.reportEventTypes.contains(event)
                  ? [
                      ...filter.value.reportEventTypes.where(
                        (element) => element != event,
                      ),
                    ]
                  : [
                      ...filter.value.reportEventTypes,
                      event,
                    ],
            ),
            label: Text(reportLabel(event)),
            labelStyle: TextStyles.s14w400cBlue2,
            side: const BorderSide(color: AppColors.blue06),
          ),
        )
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(filterType.actionLabel),
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
                                color: WidgetStateColor.resolveWith(
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
                          child: ref.watch(getInstitutionsProvider).when(
                                loading: () => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                error: (error, stack) =>
                                    Center(child: Text(error.toString())),
                                data: (institutions) =>
                                    GeneralDropdownButton<InstitutionDto>(
                                  stringMapper: (p0) => p0.name,
                                  value: institutionController
                                          .value.name.ifEmpty ??
                                      'בחירת מוסד',
                                  onChanged: (value) => institutionController
                                      .value = value ?? const InstitutionDto(),
                                  items: institutions,
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      thInstitutionSearch.clear();
                                    }
                                  },
                                  searchController: thInstitutionSearch,
                                  searchMatchFunction: (item, searchValue) =>
                                      item.value
                                          .toString()
                                          .toLowerCase()
                                          .trim()
                                          .contains(
                                            searchValue.toLowerCase().trim(),
                                          ),
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
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
            bases: filters.value.bases.contains(value.id)
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
            ),
          ),
        ),
        items: AddressRegion.regions
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
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey6,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.grey6,
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

class SelectedUsersScreen extends HookWidget {
  const SelectedUsersScreen({
    super.key,
    required this.items,
  });

  final List<PersonaDto> items;

  @override
  Widget build(BuildContext context) {
    final selected = useState(items);

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
                          title: Text(e.fullName),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: Colors.white,
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
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
