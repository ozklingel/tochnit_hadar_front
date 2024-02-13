import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/new_message_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/new_message_screen/widgets/find_users_page.dart';
import 'package:hadar_program/src/views/secondary/filter/find_objects_page.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/pick_date_and_time_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class NewOrEditMessageScreen extends HookConsumerWidget {
  const NewOrEditMessageScreen({
    super.key,
    this.id = '',
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final msg = ref.watch(newMessageControllerProvider(id: id)).valueOrNull ??
        const MessageDto();
    final selectedRecipients = useState<List<ApprenticeDto>>([]);
    final type = useState<String?>(null);
    final title = useTextEditingController();
    final body = useTextEditingController();
    final isAddUserInMsg = useState(false);

    useListenable(title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('שליחת הודעה'),
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.attach_24_filled),
            onPressed: () => Toaster.unimplemented(),
          ),
          PopupMenuButton(
            icon: const Icon(
              FluentIcons.more_vertical_24_regular,
            ),
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('שמירה בטיוטות'),
                onTap: () => Toaster.unimplemented(),
              ),
              PopupMenuItem(
                child: const Text('תזמון שליחה'),
                onTap: () async {
                  final result = await showPickDateAndTimeDialog(
                    context,
                    onTap: () => Toaster.show('submit1???'),
                  );

                  Logger().d(result);
                },
              ),
              PopupMenuItem(
                child: const Text('מחיקה'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
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
                  children: [
                    InputFieldContainer(
                      label: 'הוספת נמענים',
                      isRequired: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ActionChip(
                              label: const Text('הוספת נמענים ידנית'),
                              labelStyle: TextStyles.s14w400cBlue2,
                              side: const BorderSide(color: AppColors.blue06),
                              onPressed: () async {
                                final result = await Navigator.of(context)
                                    .push<List<ApprenticeDto>>(
                                  MaterialPageRoute(
                                    builder: (val) {
                                      return const FindUsersPage();
                                    },
                                  ),
                                );

                                if (result == null || result.isEmpty) {
                                  return;
                                }

                                selectedRecipients.value = result;
                              },
                            ),
                            const SizedBox(width: 12),
                            ActionChip(
                              label: const Text('הוספת קבוצת נמענים'),
                              labelStyle: TextStyles.s14w400cBlue2,
                              side: const BorderSide(color: AppColors.blue06),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (val) {
                                    return const FindObjectsPage.users();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (selectedRecipients.value.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ChoiceChip(
                        selected: true,
                        onSelected: (val) => selectedRecipients.value = [],
                        showCheckmark: false,
                        label: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${selectedRecipients.value.map((e) => e.fullName)}'
                                ' '
                                '(${selectedRecipients.value.length.toString()})',
                                style: TextStyles.s14w400cBlue2,
                              ),
                            ),
                            const Icon(
                              Icons.close,
                              color: AppColors.blue02,
                              size: 20,
                            ),
                          ],
                        ),
                        selectedColor: AppColors.blue06,
                      ),
                    ],
                    const SizedBox(height: 24),
                    InputFieldContainer(
                      label: 'סוג ההודעה',
                      isRequired: true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          hint: const Text(
                            'בחר את סוג ההודעה',
                            style: TextStyles.s16w400cGrey5,
                          ),
                          value: type.value,
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
                          onChanged: (value) {
                            type.value = value ?? '';
                          },
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
                          items: const [
                            DropdownMenuItem(
                              value: 'SMS',
                              child: Text('SMS'),
                            ),
                            DropdownMenuItem(
                              value: 'whatsapp',
                              child: Text('וואטסאפ'),
                            ),
                            DropdownMenuItem(
                              value: 'system',
                              child: Text('הודעת מערכת'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    InputFieldContainer(
                      label: 'כותרת',
                      isRequired: true,
                      child: TextField(
                        controller: title,
                        decoration: const InputDecoration(
                          hintText: 'הזן כותרת',
                          hintStyle: TextStyles.s16w400cGrey5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    InputFieldContainer(
                      label: 'תוכן ההודעה',
                      child: TextFormField(
                        controller: body,
                        minLines: 8,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'הזן תוכן',
                          hintStyle: TextStyles.s16w400cGrey5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Switch(
                          value: isAddUserInMsg.value,
                          onChanged: (val) =>
                              isAddUserInMsg.value = !isAddUserInMsg.value,
                        ),
                        const SizedBox(width: 12),
                        const Text('הוסף את שם הנמען בהודעה'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: LargeFilledRoundedButton(
                    label: 'שליחה',
                    onPressed: selectedRecipients.value.isEmpty ||
                            type.value == null ||
                            title.text.isEmpty
                        ? null
                        : () {
                            ref
                                .read(
                                  newMessageControllerProvider(id: '').notifier,
                                )
                                .sendMessage(msg);
                          },
                  ),
                ),
                const SizedBox(width: 12),
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
    );
  }
}
