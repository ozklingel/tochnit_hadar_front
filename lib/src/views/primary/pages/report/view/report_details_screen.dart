// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:extended_text/extended_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/impor_export/upload_file.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:logger/logger.dart';

const _kButtonHeight = 100.0;

class ReportDetailsScreen extends HookConsumerWidget {
  const ReportDetailsScreen({
    super.key,
    required this.reportId,
    required this.isReadOnly,
    required this.initRecipients,
    required this.isDupe,
    this.eventType,
    this.taskIds,
  });

  final String reportId;
  final bool isReadOnly;
  final List<String> initRecipients;
  final bool isDupe;
  final String? eventType;
  final List<String>? taskIds;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final role = (auth.valueOrNull ?? const AuthDto()).role;
    final apprentices = ref.watch(personasControllerProvider).valueOrNull ?? [];
    final report =
        (ref.watch(reportsControllerProvider).valueOrNull ?? []).singleWhere(
      (element) => element.id == reportId,
      orElse: () => ReportDto(
        recipients: initRecipients,
      ),
    );

    // Logger().d(initRecipients, error: report.recipients);

    final apprenticeSearchController = useTextEditingController();
    final selectedDatetime = useState<DateTime?>(report.dateTime.asDateTime);
    final selectedApprentices = useState(
      apprentices
          .where((element) => report.recipients.contains(element.id))
          .toList(),
    );
    final reportEvent =
        eventType != null ? Event.values.byName(eventType!) : report.event;
    final selectedEventType = useState(reportEvent);
    final uploadedFiles = useState(report.attachments);
    final isUploadInProgress = useState(<Key>[]);
    final filters = useState(const FilterDto());

    if (isReadOnly) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text('פרטי דיווח'),
          actions: [
            IconButton(
              onPressed: () => ReportEditRouteData(id: reportId).go(context),
              icon: const Icon(FluentIcons.edit_24_regular),
            ),
            PopupMenuButton(
              surfaceTintColor: Colors.white,
              offset: const Offset(0, 32),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text('שכפול'),
                    onTap: () =>
                        ReportDupeRouteData(id: reportId).push(context),
                  ),
                  PopupMenuItem(
                    child: const Text('מחיקה'),
                    onTap: () => ref
                        .read(reportsControllerProvider.notifier)
                        .delete([reportId]),
                  ),
                ];
              },
              icon: const Icon(FluentIcons.more_vertical_24_regular),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16 * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'קבוצת בה”ד 1',
                style: TextStyles.s20w400,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'תאריך',
                data: report.dateTime.asDateTime.asDayMonthYearShortDot,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'סוג האירוע',
                data: report.event.name,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'משתתפים',
                data:
                    selectedApprentices.value.map((e) => e.fullName).join(', '),
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'פירוט',
                data: report.description,
              ),
              const SizedBox(height: 12),
              Text(
                'תמונות',
                style: TextStyles.s14w400.copyWith(
                  color: AppColors.grey5,
                ),
              ),
              const SizedBox(height: 12),
              _AttachmentsWidget(
                attachments: report.attachments,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(reportId.isEmpty ? 'הוספת דיווח' : 'עריכת דיווח'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (auth.valueOrNull?.role == UserRole.melave)
                    InputFieldContainer(
                      label: 'בחירת חניכים',
                      isRequired: true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<PersonaDto>(
                          hint: selectedApprentices.value.isEmpty
                              ? const Text('בחירת חניכים')
                              : SizedBox(
                                  width: 260,
                                  child: Text(
                                    selectedApprentices.value
                                        .map((e) => e.fullName)
                                        .join(', '),
                                  ),
                                ),
                          selectedItemBuilder: (context) {
                            return (auth.valueOrNull?.apprentices ?? [])
                                .map(
                                  (e) => Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        selectedApprentices.value.isEmpty
                                            ? '?'
                                            : selectedApprentices.value.reversed
                                                .map(
                                                (e) {
                                                  return '${e.firstName} ${e.lastName}';
                                                },
                                              ).join(', '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();
                          },
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              apprenticeSearchController.clear();
                            }
                          },
                          dropdownSearchData: DropdownSearchData(
                            searchInnerWidgetHeight: 50,
                            searchController: apprenticeSearchController,
                            searchMatchFn: (
                              DropdownMenuItem<PersonaDto> item,
                              searchValue,
                            ) {
                              return item.value!.firstName
                                      .contains(searchValue) ||
                                  item.value!.lastName.contains(searchValue);
                            },
                            searchInnerWidget: TextField(
                              controller: apprenticeSearchController,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(),
                                enabledBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                hintText: 'חיפוש',
                                hintStyle: TextStyles.s14w400,
                              ),
                            ),
                          ),
                          style:
                              Theme.of(context).inputDecorationTheme.hintStyle,
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
                          items: apprentices.map(
                            (e) {
                              return DropdownMenuItem(
                                value: e,
                                enabled: false,
                                child: HookBuilder(
                                  builder: (context) {
                                    final isSelected = useState(
                                      selectedApprentices.value.contains(
                                        e,
                                      ),
                                    );

                                    return InkWell(
                                      onTap: () {
                                        isSelected.value = !isSelected.value;

                                        if (selectedApprentices.value.contains(
                                          e,
                                        )) {
                                          final newList =
                                              selectedApprentices.value;
                                          newList.remove(
                                            e,
                                          );
                                          selectedApprentices.value = [
                                            ...newList,
                                          ];
                                        } else {
                                          selectedApprentices.value = [
                                            ...selectedApprentices.value,
                                            e,
                                          ];
                                        }
                                      },
                                      child: SizedBox(
                                        height: double.infinity,
                                        child: Row(
                                          children: [
                                            if (isSelected.value)
                                              const Icon(
                                                Icons.check_box_outlined,
                                              )
                                            else
                                              const Icon(
                                                Icons.check_box_outline_blank,
                                              ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${e.firstName} ${e.lastName}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    )
                  else if (auth.valueOrNull?.role == UserRole.ahraiTohnit)
                    InputFieldContainer(
                      label: 'הוספת משתתפים',
                      isRequired: true,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(
                            label: const Text('הוספת נמענים ידנית'),
                            labelStyle: TextStyles.s14w400cBlue2,
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      _AddRecipientsManuallyScreen(
                                    initiallySelected:
                                        selectedApprentices.value,
                                  ),
                                ),
                              );

                              if (result == null) {
                                return;
                              }

                              selectedApprentices.value = result!;
                            },
                          ),
                          ActionChip(
                            label: const Text('הוספת קבוצת נמענים'),
                            labelStyle: TextStyles.s14w400cBlue2,
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              final filtersModel =
                                  await Navigator.of(context).push(
                                        MaterialPageRoute<FilterDto>(
                                          builder: (context) =>
                                              FiltersScreen.users(
                                            initFilters: filters.value,
                                          ),
                                        ),
                                      ) ??
                                      const FilterDto();

                              if (filtersModel.isEmpty) {
                                return;
                              }

                              Logger().d(filtersModel);

                              final request = await ref
                                  .read(reportsControllerProvider.notifier)
                                  .filterRecipients(filtersModel);

                              if (request.isEmpty) {
                                Toaster.warning('אין משתמשים תואמים');
                              } else {
                                selectedApprentices.value = apprentices
                                    .where(
                                      (element) => request.contains(element.id),
                                    )
                                    .toList();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  if (selectedApprentices.value.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilterChip(
                        selected: true,
                        selectedColor: AppColors.blue07,
                        showCheckmark: false,
                        label: ExtendedText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: selectedApprentices.value
                                    .map((e) => e.fullName)
                                    .join(', '),
                              ),
                              const TextSpan(text: ' '),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.blue02,
                                ),
                              ),
                            ],
                          ),
                          overflowWidget: TextOverflowWidget(
                            position: TextOverflowPosition.start,
                            align: TextOverflowAlign.left,
                            // just for debug
                            // debugOverflowRectColor:
                            //     Colors.red.withOpacity(0.1),
                            child: ColoredBox(
                              color: AppColors.blue07,
                              child: Text(
                                '(${selectedApprentices.value.length})',
                                style: TextStyles.s12w500,
                              ),
                            ),
                          ),
                        ),
                        labelStyle: TextStyles.s14w400cBlue2,
                        backgroundColor: Colors.white,
                        onSelected: (_) => selectedApprentices.value = [],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'תאריך',
                    isRequired: true,
                    child: InkWell(
                      onTap: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDatetime.value ?? DateTime.now(),
                          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                          lastDate:
                              DateTime.now().add(const Duration(days: 99000)),
                        );

                        if (newDate == null) {
                          return;
                        }

                        selectedDatetime.value = newDate;
                      },
                      borderRadius: BorderRadius.circular(36),
                      child: IgnorePointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: selectedDatetime.value == null
                                ? 'MM/DD/YY'
                                : DateFormat('dd/MM/yy')
                                    .format(selectedDatetime.value!),
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
                  InputFieldContainer(
                    label: 'סוג האירוע',
                    isRequired: true,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Event>(
                        value: selectedEventType.value == Event.other
                            ? null
                            : selectedEventType.value,
                        hint: const Text('בחירת סוג האירוע'),
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
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
                        onChanged: (value) =>
                            selectedEventType.value = value ?? Event.other,
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
                        items: Event.values
                            .where((x) => x != Event.other)
                            .where((x) {
                              switch (role) {
                                case UserRole.melave:
                                  return x.val < 200;
                                case UserRole.rakazMosad:
                                  return x.val < 300;
                                default:
                                  return true;
                              }
                            })
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name,
                                  style: TextStyles.s16w400cGrey2,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputFieldContainer(
                    label: 'תיאור האירוע',
                    child: TextField(
                      minLines: 8,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'כתוב את תיאור האירוע',
                        hintStyle: TextStyles.s16w400cGrey2.copyWith(
                          color: AppColors.grey5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    children: isUploadInProgress.value
                        .map(
                          (e) => const Padding(
                            padding: EdgeInsets.all(4),
                            child: SizedBox.square(
                              dimension: 12,
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (uploadedFiles.value.isNotEmpty)
                    _AttachmentsWidget(
                      attachments: uploadedFiles.value,
                      onDelete: (index) => uploadedFiles.value = [
                        ...uploadedFiles.value.where(
                          (element) => element != uploadedFiles.value[index],
                        ),
                      ],
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.mainCTA,
                        textStyle: TextStyles.s16w500cGrey2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                      onPressed: () async {
                        final newKey = UniqueKey();

                        isUploadInProgress.value = [
                          ...isUploadInProgress.value,
                          newKey,
                        ];

                        try {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            withData: true,
                          );

                          if (result != null) {
                            final uploadFileLocation = await ref.read(
                              uploadFileProvider(result.files.first).future,
                            );

                            uploadedFiles.value = [
                              uploadFileLocation,
                              ...uploadedFiles.value,
                            ];
                          }
                        } catch (e) {
                          Logger().e(e);
                        }

                        isUploadInProgress.value = [
                          ...isUploadInProgress.value.where((element) {
                            // Logger().d(element, error: newKey);
                            return element != newKey;
                          }),
                        ];
                      },
                      icon: const Icon(FluentIcons.add_circle_24_regular),
                      label: const Text('העלאת תמונה'),
                    ),
                  ),
                  const SizedBox(height: _kButtonHeight),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: _kButtonHeight,
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: LargeFilledRoundedButton(
                          label: reportId.isEmpty ? 'דיווח' : 'שמירה',
                          onPressed: selectedEventType.value == Event.other ||
                                  selectedDatetime.value == null ||
                                  selectedApprentices.value.isEmpty
                              ? null
                              : () async {
                                  final controllerNotifier = ref
                                      .read(reportsControllerProvider.notifier);

                                  final processedReport = report.copyWith(
                                    attachments: uploadedFiles.value,
                                    dateTime: selectedDatetime.value
                                            ?.toIso8601String() ??
                                        DateTime.now().toIso8601String(),
                                    recipients: selectedApprentices.value
                                        .map((e) => e.id)
                                        .toList(),
                                    event: selectedEventType.value,
                                  );

                                  final result = reportId.isEmpty || isDupe
                                      ? await controllerNotifier.create(
                                          processedReport,
                                          redirect: false,
                                        )
                                      : await controllerNotifier
                                          .edit(processedReport);

                                  ref
                                      .read(tasksControllerProvider.notifier)
                                      .deleteMany(taskIds);

                                  if (result && context.mounted) {
                                    final dialog = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => const SuccessDialog(
                                        msg: 'הדיווח הושלם בהצלחה!',
                                      ),
                                    ).timeout(
                                      const Duration(seconds: 2),
                                      onTimeout: () => true,
                                    );

                                    if (!context.mounted) {
                                      return;
                                    }

                                    if (dialog ?? false) {
                                      const HomeRouteData().go(context);
                                    }
                                  }
                                },
                        ),
                      ),
                      if (reportId.isNotEmpty) ...[
                        const SizedBox(width: 24),
                        Expanded(
                          child: LargeFilledRoundedButton(
                            label: 'ביטול',
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.blue02,
                            onPressed: () => const HomeRouteData().go(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentsWidget extends StatelessWidget {
  const _AttachmentsWidget({
    super.key,
    required this.attachments,
    this.onDelete,
  });

  final List<String> attachments;
  final void Function(int index)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const Text('אין תמונות');
    }

    final imageList = attachments
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: e,
                placeholder: (_, __) => const ColoredBox(
                  color: Color(0xFFD9D9D9),
                  child: SizedBox.square(dimension: 120),
                ),
              ),
            ),
          ),
        )
        .toList();

    return SizedBox(
      height: 140,
      child: GestureDetector(
        child: Stack(
          children: [
            ListView(
              scrollDirection: Axis.horizontal,
              children: imageList,
            ),
            const Icon(
              FluentIcons.zoom_in_24_regular,
              color: AppColors.grey5,
            ),
          ],
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (context, index) => Stack(
                  children: [
                    imageList[index],
                    if (onDelete != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            onDelete!(index);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            FluentIcons.delete_24_regular,
                            color: AppColors.gray5,
                          ),
                        ),
                      ),
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

class _AddRecipientsManuallyScreen extends HookConsumerWidget {
  const _AddRecipientsManuallyScreen({
    super.key,
    required this.initiallySelected,
  });

  final List<PersonaDto> initiallySelected;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref.watch(personasControllerProvider);
    final searchController = useTextEditingController();
    final selectedApprentices = useState<List<PersonaDto>>(initiallySelected);

    useListenable(searchController);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              collapsedHeight: selectedApprentices.value.isEmpty ? 60 : 100,
              automaticallyImplyLeading: false,
              pinned: true,
              flexibleSpace: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SearchBar(
                      controller: searchController,
                      elevation: MaterialStateProperty.all(0),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.blue07,
                      ),
                      leading: IconButton(
                        onPressed: () => Navigator.of(context)
                            .pop(selectedApprentices.value),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      trailing: const [Icon(Icons.search)],
                    ),
                  ),
                  if (selectedApprentices.value.isNotEmpty)
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        children: selectedApprentices.value
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: ChoiceChip(
                                  showCheckmark: false,
                                  selectedColor: AppColors.blue06,
                                  color: MaterialStateColor.resolveWith(
                                    (states) => AppColors.blue06,
                                  ),
                                  selected: true,
                                  onSelected: (val) {
                                    final newList = selectedApprentices.value;
                                    newList.remove(e);
                                    selectedApprentices.value = [...newList];
                                  },
                                  label: Row(
                                    children: [
                                      Text(e.fullName),
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
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                (apprentices.valueOrNull?.where(
                          (element) =>
                              element.fullName
                                  .toLowerCase()
                                  .contains(searchController.text) &&
                              !selectedApprentices.value.contains(element),
                        ) ??
                        [])
                    .map(
                      (e) => Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              selectedApprentices.value = [
                                e,
                                ...selectedApprentices.value,
                              ];
                            },
                            child: Text(
                              e.fullName,
                              style: TextStyles.s16w400cGrey2,
                            ),
                          ),
                        ],
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
}
