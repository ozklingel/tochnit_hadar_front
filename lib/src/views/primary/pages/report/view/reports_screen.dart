import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filter_results_page.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/cards/report_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({
    super.key,
    this.apprenticeId = '',
  });

  final String apprenticeId;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    final controller = ref.watch<AsyncValue<List<ReportDto>>>(
      reportsControllerProvider.select(
        (value) {
          if (value.isLoading) {
            return const AsyncValue.loading();
          }

          if (value.hasError) {
            return AsyncValue.error(
              value.error.toString(),
              value.stackTrace ?? StackTrace.current,
            );
          }

          if (apprenticeId.isEmpty) {
            return AsyncValue.data(value.value!);
          }

          return AsyncData(
            value.value!
                .where(
                  (element) => element.apprenticeId == apprenticeId,
                )
                .toList(),
          );
        },
      ),
    );

    final selectedIds = useState(<String>[]);
    final filters = useState(<String>['test1', 'test2']);
    final sortBy = useState(SortReportBy.fromA2Z);

    if (user.valueOrNull?.role == UserRole.ahraiTohnit) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('דיווחים'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => const ReportNewRouteData().push(context),
          shape: const CircleBorder(),
          backgroundColor: AppColors.blue02,
          child: const Icon(
            FluentIcons.add_24_regular,
            color: Colors.white,
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () => ref.refresh(reportsControllerProvider.future),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: filters.value.isEmpty ? 82 : 132,
                collapsedHeight: filters.value.isEmpty ? 82 : 132,
                pinned: true,
                flexibleSpace: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: SearchBar(
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
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.blue08,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FilterResultsPage.reports(),
                                  ),
                                ),
                                icon: const Icon(
                                  FluentIcons.filter_add_20_regular,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.red1,
                                  radius: 7,
                                  child: Text(
                                    filters.value.length.toString(),
                                    style: TextStyles.s11w500fRoboto,
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
                            children: filters.value
                                .map(
                                  (e) => ChoiceChip(
                                    showCheckmark: false,
                                    selectedColor: AppColors.blue06,
                                    color: MaterialStateColor.resolveWith(
                                      (states) => AppColors.blue06,
                                    ),
                                    selected: true,
                                    onSelected: (val) =>
                                        Toaster.unimplemented(),
                                    label: Row(
                                      children: [
                                        Text(e),
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
                              case SortReportBy.fromA2Z:
                                sortBy.value = SortReportBy.fromA2Z;
                                ref
                                    .read(reportsControllerProvider.notifier)
                                    .sortBy(SortReportBy.fromA2Z);
                                break;
                              case SortReportBy.timeFromCloseToFar:
                                sortBy.value = SortReportBy.timeFromCloseToFar;
                                ref
                                    .read(reportsControllerProvider.notifier)
                                    .sortBy(SortReportBy.timeFromCloseToFar);
                                break;
                              case SortReportBy.timeFromFarToClose:
                                sortBy.value = SortReportBy.timeFromFarToClose;
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
              controller.when(
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Text(controller.error.toString()),
                  ),
                ),
                loading: () => SliverFillRemaining(
                  child: _ReporsListBody(
                    reports: List.generate(
                      10,
                      (index) => const ReportDto(),
                    ),
                    isLoading: true,
                    selectedIds: selectedIds,
                  ),
                ),
                data: (reports) => SliverFillRemaining(
                  child: _ReporsListBody(
                    reports: reports,
                    isLoading: false,
                    selectedIds: selectedIds,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (selectedIds.value.isEmpty)
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.search_24_regular),
            )
          else if (selectedIds.value.length == 1) ...[
            IconButton(
              onPressed: () =>
                  ReportEditRouteData(id: selectedIds.value.first).go(context),
              icon: const Icon(
                FluentIcons.edit_24_regular,
                size: 16,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(FluentIcons.more_vertical_24_regular),
              surfaceTintColor: Colors.white,
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('שכפול'),
                  onTap: () => Toaster.unimplemented(),
                ),
                PopupMenuItem(
                  child: const Text('עריכה'),
                  onTap: () => ReportEditRouteData(id: selectedIds.value.first)
                      .go(context),
                ),
                PopupMenuItem(
                  child: const Text('מחיקה'),
                  onTap: () => Toaster.unimplemented(),
                ),
                PopupMenuItem(
                  child: const Text('פרופיל אישי'),
                  onTap: () => Toaster.unimplemented(),
                ),
              ],
            ),
          ] else
            IconButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => Dialog(
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
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'מחיקת 2 דיווחים',
                                      style: TextStyles.s24w400,
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                      text:
                                          'האם אתה מעוניין למחוק את הדיווחים שנבחרו? ',
                                      style: TextStyles.s16w400cGrey2,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              LargeFilledRoundedButton(
                                label: 'לא, השאר',
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              const SizedBox(height: 16),
                              LargeFilledRoundedButton(
                                label: 'כן, מחק',
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.blue03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                if (result == null || !result) {
                  return;
                }

                Toaster.unimplemented();
              },
              icon: const Icon(FluentIcons.delete_24_regular),
            ),
          const SizedBox(width: 16),
        ],
        title: const Text('דיווחים'),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.blue02,
        foregroundColor: AppColors.blue06,
        child: const Icon(FluentIcons.add_32_filled),
        onPressed: () => const ReportNewRouteData().go(context),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(reportsControllerProvider.future),
        child: controller.when(
          error: (error, stack) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: Text(controller.error.toString()),
                ),
              ),
            ],
          ),
          loading: () => _ReporsListBody(
            reports: List.generate(
              10,
              (index) => ReportDto(
                dateTime: DateTime.now().toIso8601String(),
              ),
            ),
            isLoading: true,
            selectedIds: selectedIds,
          ),
          data: (reports) => _ReporsListBody(
            reports: reports,
            isLoading: false,
            selectedIds: selectedIds,
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
                value: SortReportBy.fromA2Z,
                groupValue: sortVal.value,
                onChanged: (_) =>
                    Navigator.of(context).pop(SortReportBy.fromA2Z),
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
    required this.selectedIds,
  });

  final List<ReportDto> reports;
  final ValueNotifier<List<String>> selectedIds;
  final bool isLoading;

  @override
  Widget build(BuildContext context, ref) {
    if (reports.isEmpty && !isLoading) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Assets.images.noMessages.svg(),
                const Text(
                  'אין הודעות נכנסות',
                  textAlign: TextAlign.center,
                  style: TextStyles.s20w500,
                ),
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

    final children = reports
        .map(
          (e) => Skeletonizer(
            enabled: isLoading,
            child: ReportCard(
              report: e,
              isSelected: selectedIds.value.contains(e.id),
              onTap: () => ReportDetailsRouteData(id: e.id).push(context),
              onLongPress: () {
                if (selectedIds.value.contains(e.id)) {
                  final newList = selectedIds;
                  newList.value.remove(e.id);
                  selectedIds.value = [...newList.value];
                } else {
                  selectedIds.value = [
                    ...selectedIds.value,
                    e.id,
                  ];
                }
              },
            ),
          ),
        )
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: children.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => children[index],
    );
  }
}
