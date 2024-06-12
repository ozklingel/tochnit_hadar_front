import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/find_users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/states/error_state.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessagePersonasScreen extends HookConsumerWidget {
  const MessagePersonasScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final searchController = useTextEditingController();
    final findUsersController = ref.watch(
      findUsersControllerProvider(
        searchTerm: searchController.text,
      ),
    );
    final searchedUsers = useState(<PersonaDto>[]);
    final selectedUsers = useState(<PersonaDto>[]);

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
            elevation: WidgetStateProperty.all(0),
            backgroundColor:
                WidgetStateColor.resolveWith((states) => AppColors.blue07),
            hintText: 'הזן את שם המשתמש',
            hintStyle: WidgetStateProperty.all(TextStyles.s16w400cGrey5),
            leading: IconButton(
              icon: const Icon(FluentIcons.arrow_left_24_filled),
              onPressed: () => Navigator.of(context).pop(),
            ),
            padding: WidgetStateProperty.all(
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
                child: findUsersController.when(
                  loading: () => const LoadingState(),
                  error: (error, _) => ErrorState(error),
                  data: (list) => list.isEmpty
                      ? const Center(child: Text('NO USERS FOUND'))
                      : ListView(
                          children: list
                              .where(
                                (element) =>
                                    !selectedUsers.value.contains(element),
                              )
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
