import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/views/new_message_screen/widgets/message_personas_screen.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/pick_date_and_time_dialog.dart';
import 'package:hadar_program/src/views/widgets/dialogs/success_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NewOrEditMessageScreen extends HookConsumerWidget {
  const NewOrEditMessageScreen({
    super.key,
    this.id = '',
    this.isDupe = false,
    this.initRecipients = const [],
  });

  final String id;
  final bool isDupe;
  final List<String> initRecipients;

  @override
  Widget build(BuildContext context, ref) {
    final msg =
        (ref.watch(messagesControllerProvider).valueOrNull ?? []).singleWhere(
      (element) => element.id == id,
      orElse: () => const MessageDto(),
    );
    final personas = ref.watch(getPersonasProvider).valueOrNull ?? [];
    final selectedRecipients = useState(<PersonaDto>[]);
    final method = useState(MessageMethod.other);
    final title = useTextEditingController(text: msg.title);
    final body = useTextEditingController(text: msg.content);
    final isAddUserInMsg = useState(false);
    final filters = useState(const FilterDto());

    useEffect(
      () {
        final filteredUsers = personas
            .where(
              (element) =>
                  initRecipients.contains(element.id) ||
                  msg.to.contains(element.id),
            )
            .toList();

        title.text = msg.title;
        body.text = msg.content;
        method.value = msg.method;
        selectedRecipients.value = filteredUsers;

        return null;
      },
      [personas, msg],
    );

    useListenable(title);

    // Logger().d(
    //   personas.length,
    //   error: personas
    //       .where(
    //         (element) =>
    //             initRecipients.contains(element.id) ||
    //             msg.to.contains(element.id),
    //       )
    //       .toList(),
    // );

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        // final navContext = Navigator.of(context);

        // if (didPop) {
        //   return;
        // }

        if (title.text.isNotEmpty ||
            body.text.isNotEmpty ||
            selectedRecipients.value.isNotEmpty) {
          final newMsg = msg.copyWith(
            type: MessageType.draft,
            method: method.value,
            title: title.text,
            content: body.text,
            to: selectedRecipients.value.map((e) => e.id).toList(),
          );

          // final result =
          final result = id.isEmpty
              ? await ref
                  .read(messagesControllerProvider.notifier)
                  .create(newMsg)
              : await ref
                  .read(messagesControllerProvider.notifier)
                  .edit(newMsg);

          if (result) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }

          // Logger().d(result);

          // if (result) {
          //   navContext.pop();
          // } else {
          //   Toaster.error('failed to save');
          // }
        }

        // navContext.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text('שליחת הודעה'),
          actions: [
            // IconButton(
            //   icon: const Icon(FluentIcons.attach_24_filled),
            //   onPressed: () => Toaster.unimplemented(),
            // ),
            PopupMenuButton(
              icon: const Icon(
                FluentIcons.more_vertical_24_regular,
              ),
              offset: const Offset(0, 40),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('שמירה בטיוטות'),
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                PopupMenuItem(
                  child: const Text('תזמון שליחה'),
                  onTap: () async {
                    final result = await showPickDateAndTimeDialog(
                      context,
                      onTap: () => Toaster.error('backend?'),
                    );

                    Logger().d(result);
                  },
                ),
                PopupMenuItem(
                  child: const Text('מחיקה'),
                  onTap: () {
                    selectedRecipients.value = [];
                    title.text = '';
                    body.text = '';

                    Navigator.of(context).maybePop();
                  },
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
                                      .push<List<PersonaDto>>(
                                    MaterialPageRoute(
                                      builder: (val) {
                                        return const MessagePersonasScreen();
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
                                onPressed: () async {
                                  final filter = await Navigator.of(context)
                                      .push<FilterDto>(
                                    MaterialPageRoute(
                                      builder: (val) => FiltersScreen.users(
                                        initFilters: filters.value,
                                      ),
                                    ),
                                  );

                                  if (filter == null) {
                                    return;
                                  } else if (filter.isEmpty) {
                                    filters.value = const FilterDto();
                                  }

                                  BotToast.showLoading();

                                  try {
                                    final req = await ref.read(
                                      getFilteredUsersProvider(filter).future,
                                    );

                                    final filtered = (await ref
                                            .read(getPersonasProvider.future))
                                        .where(
                                          (element) => req.contains(element.id),
                                        )
                                        .toList();

                                    selectedRecipients.value = filtered;
                                  } catch (e) {
                                    Logger()
                                        .e('failed to filter users', error: e);
                                    Sentry.captureException(e);
                                    Toaster.error(e);
                                  }

                                  BotToast.closeAllLoading();
                                },
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
                          child: DropdownButton2<MessageMethod>(
                            hint: Text(
                              method.value == MessageMethod.other
                                  ? 'בחר את סוג ההודעה'
                                  : method.value.name,
                              style: TextStyles.s16w400cGrey5,
                            ),
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
                              method.value = value ?? MessageMethod.other;
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
                            items: [
                              DropdownMenuItem(
                                value: MessageMethod.sms,
                                child: Text(MessageMethod.sms.name),
                              ),
                              DropdownMenuItem(
                                value: MessageMethod.whatsapp,
                                child: Text(MessageMethod.whatsapp.name),
                              ),
                              DropdownMenuItem(
                                value: MessageMethod.system,
                                child: Text(MessageMethod.system.name),
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
                              title.text.isEmpty
                          ? null
                          : () async {
                              final controllerNotifier =
                                  ref.read(messagesControllerProvider.notifier);
                              final newMsg = msg.copyWith(
                                to: selectedRecipients.value
                                    .map((e) => e.id)
                                    .toList(),
                                method: method.value,
                                title: title.text,
                                content: body.text,
                              );
                              final result = id.isEmpty || isDupe
                                  ? await controllerNotifier.create(newMsg)
                                  : await controllerNotifier.edit(newMsg);

                              if (result && context.mounted) {
                                final res2 = await showDialog(
                                      context: context,
                                      builder: (context) => const SuccessDialog(
                                        msg: 'הודעה נשלחה בהצלחה!',
                                      ),
                                    ) ??
                                    true;

                                if (res2) {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LargeFilledRoundedButton.cancel(
                      label: 'ביטול',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
