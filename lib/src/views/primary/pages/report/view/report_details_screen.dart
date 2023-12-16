import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/primary/pages/report/controller/reports_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
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
    final report =
        ref.watch(reportsControllerProvider).valueOrNull?.singleWhere(
                  (element) => element.id == reportId,
                  orElse: () => const ReportDto(),
                ) ??
            const ReportDto();
    final reportApprentices = ref
            .watch(apprenticesControllerProvider)
            .valueOrNull
            ?.where((element) => report.apprentices.contains(element.id))
            .toList() ??
        [];
    final apprenticeSearchController = useTextEditingController();
    final selectedDatetime = useState<DateTime?>(report.dateTime.asDateTime);
    final selectedApprentices = useState(reportApprentices);
    final selectedEventType = useState(report.reportEventType);

    if (isReadOnly) {
      return Scaffold(
        appBar: AppBar(
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
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    12,
                    (index) => const Padding(
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
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'בחירת חניכים'),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColors.red2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<ApprenticeDto>(
                      value: user.apprentices
                              .firstWhere(
                                (element) =>
                                    selectedApprentices.value.contains(element),
                                orElse: () => const ApprenticeDto(),
                              )
                              .id
                              .isEmpty
                          ? null
                          : user.apprentices.firstWhere(
                              (element) =>
                                  selectedApprentices.value.contains(element),
                            ),
                      hint: const Text('בחירת חניכים'),
                      selectedItemBuilder: (context) {
                        return user.apprentices
                            .map(
                              (e) => Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
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
                          return item.value!.firstName.contains(searchValue) ||
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
                      items: user.apprentices
                          .map(
                            (e) => DropdownMenuItem(
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
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'תאריך'),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColors.red2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
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
                  const SizedBox(height: 24),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'סוג האירוע'),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColors.red2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonHideUnderline(
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
                  const SizedBox(height: 24),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'תיאור האירוע'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    minLines: 8,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'כתוב את תיאור האירוע',
                      hintStyle: TextStyles.s16w400cGrey2.copyWith(
                        color: AppColors.grey5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        final result = await FilePicker.platform
                            .pickFiles(allowMultiple: true);

                        if (result == null) {
                          return;
                        }

                        // TODO(noga-dev): upload files to backend storage then save the urls in the report
                        // ignore: unused_local_variable
                        final files =
                            result.paths.map((path) => File(path!)).toList();
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SuccessDialog(
                                msg: 'הדיווח הושלם בהצלחה!',
                              ),
                            );

                            // TODO(noga-dev): account for new or edit

                            Toaster.unimplemented();
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
