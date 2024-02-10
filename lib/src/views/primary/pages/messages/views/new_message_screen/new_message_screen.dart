import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/new_message_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filter_results_page.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/dialogs/pick_date_and_time_dialog.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class NewMessageScreen extends HookConsumerWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedRecipients = useState<List<ApprenticeDto>>([]);
    final type = useState<String?>(null);
    final title = useTextEditingController();
    final body = useTextEditingController();
    final isAddUserInMsg = useState(false);

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
                                return const _FindUsersPage();
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
                              return const FilterResultsPage.users();
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: LargeFilledRoundedButton(
                      label: 'שליחה',
                      onPressed: () async {},
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
      ),
    );
  }
}

class _FindUsersPage extends HookConsumerWidget {
  const _FindUsersPage();

  @override
  Widget build(BuildContext context, ref) {
    final searchController = useTextEditingController();
    final newMsgController = ref.watch(
      newMessageControllerProvider(
        searchTerm: searchController.text,
      ),
    );
    final searchedUsers = useState<List<ApprenticeDto>>([]);
    final selectedUsers = useState<List<ApprenticeDto>>([]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SearchBar(
            controller: searchController,
            onChanged: (val) async {
              // TODO add debouncer
              searchedUsers.value = [
                ...await ref
                    .read(messagesControllerProvider.notifier)
                    .searchApprentices(val),
              ];
            },
            elevation: MaterialStateProperty.all(0),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => AppColors.blue07),
            hintText: 'הזן את שם המשתמש',
            hintStyle: MaterialStateProperty.all(TextStyles.s16w400cGrey5),
            leading: const Icon(FluentIcons.arrow_left_24_filled),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16),
            ),
            trailing: const [
              Icon(FluentIcons.search_24_filled),
            ],
          ),
          bottom: selectedUsers.value.isEmpty
              ? null
              : PreferredSize(
                  preferredSize: Size(
                    MediaQuery.of(context).size.width,
                    52,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: selectedUsers.value
                              .map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: ActionChip(
                                    backgroundColor: AppColors.blue06,
                                    onPressed: () {
                                      final newList = selectedUsers.value;
                                      newList.remove(e);
                                      selectedUsers.value = [...newList];
                                    },
                                    label: Row(
                                      children: [
                                        Text(
                                          e.fullName,
                                          style: TextStyles.s14w400cBlue2,
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.close,
                                          color: AppColors.blue02,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [
                0,
                0.04,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: newMsgController.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  error: (error, stack) =>
                      Center(child: Text(error.toString())),
                  data: (list) => ListView(
                    children: list
                        .map(
                          (e) => ListTile(
                            title: Text(e.fullName),
                            onTap: () {
                              if (selectedUsers.value.contains(e)) {
                                return;
                              }

                              selectedUsers.value = [
                                e,
                                ...selectedUsers.value,
                              ];
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              if (selectedUsers.value.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          height: 36,
                          child: LargeFilledRoundedButton(
                            label: 'הוסף',
                            fontSize: 12,
                            onPressed: () {
                              Navigator.of(context).pop(selectedUsers.value);
                            },
                          ),
                        ),
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
