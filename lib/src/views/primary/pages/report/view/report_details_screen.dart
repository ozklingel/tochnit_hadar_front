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
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/api/impor_export/upload_file.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
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
  });

  final String reportId;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];
    final report =
        ref.watch(reportsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == reportId,
                  orElse: () => const ReportDto(),
                ) ??
            const ReportDto();
    final reportApprentices = ref
            .watch(apprenticesControllerProvider)
            .valueOrNull
            ?.where((element) => report.recipients.contains(element.id))
            .toList() ??
        [];
    final apprenticeSearchController = useTextEditingController();
    final selectedDatetime = useState<DateTime?>(report.dateTime.asDateTime);
    final selectedApprentices = useState(reportApprentices);
    final selectedEventType = useState(report.reportEventType);
    final uploadedFiles = useState(<String>[]);
    final isUploadInProgress = useState(<Key>[]);

    if (isReadOnly) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                    onTap: () => Toaster.unimplemented(),
                  ),
                  PopupMenuItem(
                    child: const Text('מחיקה'),
                    onTap: () => Toaster.unimplemented(),
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
                data: report.reportEventType.name,
              ),
              const SizedBox(height: 12),
              DetailsRowItem(
                label: 'משתתפים',
                data: reportApprentices
                    .map((e) => '${e.firstName} ${e.lastName}')
                    .join(', '),
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
              const _AttachmentsWidget(
                attachments: [],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                  if (user.valueOrNull?.role == UserRole.melave)
                    InputFieldContainer(
                      label: 'בחירת חניכים',
                      isRequired: true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<ApprenticeDto>(
                          value: (apprentices
                                  .singleWhere(
                                    (element) => selectedApprentices.value
                                        .contains(element),
                                    orElse: () => const ApprenticeDto(),
                                  )
                                  .id
                                  .isEmpty)
                              ? null
                              : apprentices.singleWhere(
                                  (element) => selectedApprentices.value
                                      .contains(element),
                                  orElse: () => const ApprenticeDto(),
                                ),
                          hint: const Text('בחירת חניכים'),
                          selectedItemBuilder: (context) {
                            return (user.valueOrNull?.apprentices ?? [])
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
                              DropdownMenuItem<ApprenticeDto> item,
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
                  else if (user.valueOrNull?.role == UserRole.ahraiTohnit)
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
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FiltersScreen.addRecipients(),
                              ),
                            ),
                          ),
                          if (selectedApprentices.value.isNotEmpty)
                            FilterChip(
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
                        ],
                      ),
                    ),
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
                      child: DropdownButton2(
                        value: selectedEventType.value == ReportEventType.none
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
                        onChanged: (value) => selectedEventType.value =
                            value ?? ReportEventType.none,
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
                        items: ReportEventType.values
                            .where((x) => x != ReportEventType.none)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
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

                          // if (result == null) {
                          //   return;
                          // }

                          // if (result.paths.length > 1) {
                          //   Toaster.error('too many');
                          //   return;
                          // }

                          // TODO(noga-dev): upload files to backend storage then save the urls in the report
                          // ignore: unused_local_variable
                          // final files =
                          //     result.paths.map((path) => File(path!)).toList();

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
                          onPressed: selectedEventType.value ==
                                      ReportEventType.none ||
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
                                    reportEventType: selectedEventType.value,
                                  );

                                  final result = reportId.isEmpty
                                      ? await controllerNotifier
                                          .create(processedReport)
                                      : await controllerNotifier
                                          .edit(processedReport);

                                  if (result && context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const SuccessDialog(
                                        msg: 'הדיווח הושלם בהצלחה!',
                                      ),
                                    );
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
  });

  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: attachments
            .map(
              (e) => CachedNetworkImage(
                imageUrl: e,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: ColoredBox(
                      color: Color(0xFFD9D9D9),
                      child: SizedBox.square(
                        dimension: 120,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AddRecipientsManuallyScreen extends HookConsumerWidget {
  const _AddRecipientsManuallyScreen({
    super.key,
    required this.initiallySelected,
  });

  final List<ApprenticeDto> initiallySelected;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices = ref.watch(apprenticesControllerProvider);
    final searchController = useTextEditingController();
    final selectedApprentices =
        useState<List<ApprenticeDto>>(initiallySelected);

    useListenable(searchController);

    return Scaffold(
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
                      onPressed: () =>
                          Navigator.of(context).pop(selectedApprentices.value),
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
                          child: Text(e.fullName),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
