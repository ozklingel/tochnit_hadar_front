// ignore_for_file: unused_element

import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/theming/widgets.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/reports_form/get_reports.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/widgets/appbars/search_appbar.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/report_card.dart';
import 'package:hadar_program/src/views/widgets/chips/filter_chip.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({
    super.key,
    this.personaId = '',
  });

  final String personaId;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final personas = ref.watch(getPersonasProvider).valueOrNull ?? [];
    final controller = ref.watch(reportsControllerProvider);
    final selectedReportIds = useState(<String>[]);
    final filters = useState(const FilterDto());
    final sortBy = useState(SortReportBy.abcAscending);
    final isSearchOpen = useState(false);
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    useListenable(searchController);

    var sortedReports = (controller.valueOrNull ?? []).where((element) {
      if (personaId.isEmpty) {
        return true;
      }
      return element.recipients.contains(personaId);
    }).sorted((a, b) {
      switch (sortBy.value) {
        case SortReportBy.abcAscending:
          return a.event.name.compareTo(b.event.name);
        case SortReportBy.timeFromCloseToFar:
          return a.creationDate.asDateTime.compareTo(b.creationDate.asDateTime);
        default:
          return 0;
      }
    });

    if (sortBy.value == SortReportBy.timeFromFarToClose) {
      sortedReports = sortedReports.reversed.toList();
    }

    if (auth.valueOrNull?.role == UserRole.ahraiTohnit) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('דיווחים'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              const ReportNewRouteData(initRecipients: []).push(context),
          heroTag: UniqueKey(),
          shape: const CircleBorder(),
          backgroundColor: AppColors.blue02,
          child: const Icon(
            FluentIcons.add_24_regular,
            color: Colors.white,
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () {
            selectedReportIds.value = [];

            return ref.refresh(getReportsProvider.future);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: filters.value.isEmpty ? 96 : 144,
                collapsedHeight: filters.value.isEmpty ? 96 : 144,
                automaticallyImplyLeading: false,
                pinned: true,
                flexibleSpace: BottomShadowWidget(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: SearchBar(
                                  controller: searchController,
                                  elevation: MaterialStateProperty.all(0),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  leading: const Icon(
                                    FluentIcons.navigation_24_regular,
                                    size: 18,
                                  ),
                                  trailing: const [
                                    Icon(
                                      FluentIcons.search_24_regular,
                                      size: 18,
                                    ),
                                  ],
                                  hintText: 'חיפוש',
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) => AppColors.blue08,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final result =
                                        await Navigator.of(context).push(
                                              MaterialPageRoute<FilterDto>(
                                                builder: (context) =>
                                                    FiltersScreen.reports(
                                                  initFilters: filters.value,
                                                ),
                                              ),
                                            ) ??
                                            const FilterDto();

                                    final request = await ref
                                        .read(
                                          reportsControllerProvider.notifier,
                                        )
                                        .filterReports(result);

                                    if (request) {
                                      filters.value = result;
                                    }
                                  },
                                  icon: const Icon(
                                    FluentIcons.filter_add_20_regular,
                                  ),
                                ),
                                if (filters.value.isNotEmpty)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: IgnorePointer(
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.red1,
                                        radius: 7,
                                        child: Text(
                                          filters.value.length.toString(),
                                          style: TextStyles.s11w500fRoboto,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (filters.value.isNotEmpty)
                        SizedBox(
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...filters.value.reportEventTypes.map(
                                  (e) => FilterChipWidget(
                                    text: e.name,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      roles: filters.value.roles
                                          .where((element) => element != e.name)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.roles.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      roles: filters.value.roles
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.years.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      years: filters.value.years
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.institutions.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      institutions: filters.value.institutions
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.periods.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      periods: filters.value.periods
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.eshkols.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      eshkols: filters.value.eshkols
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.statuses.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      statuses: filters.value.statuses
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.bases.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      bases: filters.value.bases
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.hativot.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      hativot: filters.value.hativot
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.regions.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      regions: filters.value.regions
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                ...filters.value.cities.map(
                                  (e) => FilterChipWidget(
                                    text: e,
                                    onTap: () =>
                                        filters.value = filters.value.copyWith(
                                      cities: filters.value.cities
                                          .where((element) => element != e)
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ]
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: e,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () async {
                              final result = await showDialog<SortReportBy?>(
                                context: context,
                                builder: (context) => _SortByDialog(
                                  initialVal: sortBy.value,
                                ),
                              );

                              switch (result) {
                                case SortReportBy.abcAscending:
                                  sortBy.value = SortReportBy.abcAscending;
                                  ref
                                      .read(reportsControllerProvider.notifier)
                                      .sortBy(SortReportBy.abcAscending);
                                  break;
                                case SortReportBy.timeFromCloseToFar:
                                  sortBy.value =
                                      SortReportBy.timeFromCloseToFar;
                                  ref
                                      .read(reportsControllerProvider.notifier)
                                      .sortBy(SortReportBy.timeFromCloseToFar);
                                  break;
                                case SortReportBy.timeFromFarToClose:
                                  sortBy.value =
                                      SortReportBy.timeFromFarToClose;
                                  ref
                                      .read(reportsControllerProvider.notifier)
                                      .sortBy(SortReportBy.timeFromFarToClose);
                                  break;
                                case null:
                                  return;
                              }
                            },
                            icon: const Icon(
                              FluentIcons.arrow_sort_down_lines_24_regular,
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: _ReporsListBody(
                  scrollController: scrollController,
                  isLoading: controller.isLoading,
                  selectedReportIds: selectedReportIds,
                  reports: controller.isLoading
                      ? List.generate(
                          10,
                          (index) => ReportDto(
                            dateTime: DateTime.now().toIso8601String(),
                          ),
                        )
                      : sortedReports
                          .where(
                            (element) =>
                                // element.description.toLowerCase().contains(
                                //       searchController.text.toLowerCase(),
                                //     ) ||
                                // element.reportEventType.name
                                //     .toLowerCase()
                                //     .contains(
                                //       searchController.text.toLowerCase(),
                                //     ) ||
                                element.search.toLowerCase().contains(
                                      searchController.text.toLowerCase(),
                                    ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: SearchAppBar(
        title: const Text('דיווחים'),
        isSearchOpen: isSearchOpen,
        controller: searchController,
        actions: [
          if (selectedReportIds.value.isEmpty)
            IconButton(
              onPressed: () => isSearchOpen.value = true,
              icon: const Icon(FluentIcons.search_24_regular),
            )
          else if (selectedReportIds.value.length == 1) ...[
            IconButton(
              onPressed: () =>
                  ReportEditRouteData(id: selectedReportIds.value.first)
                      .go(context),
              icon: const Icon(
                FluentIcons.edit_24_regular,
                size: 16,
              ),
            ),
            Builder(
              builder: (context) {
                final report = sortedReports.singleWhere(
                  (element) => element.id == selectedReportIds.value.first,
                  orElse: () => const ReportDto(),
                );
                final recipient = personas.singleWhere(
                  (element) => report.recipients.contains(element.id),
                  orElse: () => const PersonaDto(),
                );

                return PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  surfaceTintColor: Colors.white,
                  offset: const Offset(0, 32),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('שכפול'),
                      onTap: () =>
                          ReportDupeRouteData(id: selectedReportIds.value.first)
                              .push(context),
                    ),
                    PopupMenuItem(
                      child: const Text('עריכה'),
                      onTap: () =>
                          ReportEditRouteData(id: selectedReportIds.value.first)
                              .go(context),
                    ),
                    PopupMenuItem(
                      child: const Text('מחיקה'),
                      onTap: () async {
                        final isConfirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => _DeleteConfirmationDialog(
                                count: selectedReportIds.value.length,
                              ),
                            ) ??
                            false;

                        if (isConfirm) {
                          final isSuccess = await ref
                              .read(reportsControllerProvider.notifier)
                              .delete([selectedReportIds.value.first]);

                          if (isSuccess) {
                            selectedReportIds.value = [];
                          }
                        }
                      },
                    ),
                    if (recipient.id.isNotEmpty)
                      PopupMenuItem(
                        child: const Text('פרופיל אישי'),
                        onTap: () => PersonaDetailsRouteData(id: recipient.id)
                            .push(context),
                      ),
                  ],
                );
              },
            ),
          ] else
            IconButton(
              onPressed: () async {
                final isConfirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => _DeleteConfirmationDialog(
                        count: selectedReportIds.value.length,
                      ),
                    ) ??
                    false;

                if (isConfirm) {
                  final isSuccess = await ref
                      .read(reportsControllerProvider.notifier)
                      .delete(selectedReportIds.value);

                  if (isSuccess) {
                    selectedReportIds.value = [];
                  }
                }
              },
              icon: const Icon(FluentIcons.delete_24_regular),
            ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        heroTag: UniqueKey(),
        backgroundColor: AppColors.blue02,
        foregroundColor: AppColors.blue06,
        child: const Icon(FluentIcons.add_32_filled),
        onPressed: () =>
            const ReportNewRouteData(initRecipients: []).go(context),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          selectedReportIds.value = [];
          return ref.refresh(getReportsProvider.future);
        },
        child: _ReporsListBody(
          scrollController: scrollController,
          isLoading: controller.isLoading,
          selectedReportIds: selectedReportIds,
          reports: controller.isLoading
              ? List.generate(
                  10,
                  (index) => ReportDto(
                    dateTime: DateTime.now().toIso8601String(),
                  ),
                )
              : sortedReports
                  .where(
                    (element) =>
                        element.description
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) ||
                        element.event.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        color: MaterialStateColor.resolveWith(
          (states) => AppColors.blue06,
        ),
        selected: true,
        onSelected: (val) => Toaster.unimplemented(),
        label: Row(
          children: [
            Text(label),
            const SizedBox(width: 8),
            const Icon(
              Icons.close,
              color: AppColors.blue02,
              size: 16,
            ),
          ],
        ),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(
          color: AppColors.blue06,
        ),
      ),
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  const _DeleteConfirmationDialog({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 360,
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'מחיקת $count דיווחים',
                        style: TextStyles.s24w400,
                      ),
                      const TextSpan(text: '\n'),
                      const TextSpan(text: '\n'),
                      const TextSpan(
                        text: 'האם אתה מעוניין למחוק את הדיווחים שנבחרו? ',
                        style: TextStyles.s16w400cGrey2,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                LargeFilledRoundedButton(
                  label: 'לא, השאר',
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(height: 16),
                LargeFilledRoundedButton(
                  label: 'כן, מחק',
                  onPressed: () => Navigator.of(context).pop(true),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.blue03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SortByDialog extends HookWidget {
  const _SortByDialog({
    super.key,
    required this.initialVal,
  });

  final SortReportBy initialVal;

  @override
  Widget build(BuildContext context) {
    final sortVal = useState(initialVal);

    return Dialog(
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            runSpacing: 8,
            runAlignment: WrapAlignment.center,
            children: [
              const Text(
                'מיין לפי',
                style: TextStyles.s16w400cGrey5,
              ),
              RadioListTile(
                value: SortReportBy.abcAscending,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortReportBy.abcAscending),
                title: const Text('א-ב'),
              ),
              RadioListTile(
                value: SortReportBy.timeFromCloseToFar,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortReportBy.timeFromCloseToFar),
                title: const Text('זמן: מהקרוב אל הרחוק'),
              ),
              RadioListTile(
                value: SortReportBy.timeFromFarToClose,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortReportBy.timeFromFarToClose),
                title: const Text('זמן: מרחוק אל הקרוב'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReporsListBody extends ConsumerWidget {
  const _ReporsListBody({
    required this.reports,
    required this.isLoading,
    required this.selectedReportIds,
    required this.scrollController,
  });

  final List<ReportDto> reports;
  final ValueNotifier<List<String>> selectedReportIds;
  final bool isLoading;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, ref) {
    if (reports.isEmpty && !isLoading) {
      return CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Assets.illustrations.pointDown.svg(),
                const Text(
                  'אין דיווחים',
                  textAlign: TextAlign.center,
                  style: TextStyles.s20w500,
                ),
                const SizedBox(height: 8),
                const Text(
                  'הודעות נכנסות שישלחו, יופיעו כאן',
                  textAlign: TextAlign.center,
                  style: TextStyles.s14w400,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Logger().d(selectedIds.value);

    final children = reports.map(
      (e) {
        return Skeletonizer(
          enabled: isLoading,
          child: ReportCard(
            report: e,
            isSelected: selectedReportIds.value.contains(e.id),
            onTap: selectedReportIds.value.isEmpty
                ? () => ReportDetailsRouteData(id: e.id).push(context)
                : () => _selectReport(
                      e: e,
                      selectedReportIds: selectedReportIds,
                    ),
            onLongPress: () => _selectReport(
              e: e,
              selectedReportIds: selectedReportIds,
            ),
          ),
        );
      },
    ).toList();

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: children.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => children[index],
    );
  }
}

void _selectReport({
  required ValueNotifier<List<String>> selectedReportIds,
  required ReportDto e,
}) {
  if (selectedReportIds.value.contains(e.id)) {
    selectedReportIds.value = [
      ...selectedReportIds.value.where((element) => element != e.id),
    ];
  } else {
    selectedReportIds.value = [
      ...selectedReportIds.value,
      e.id,
    ];
  }
}
