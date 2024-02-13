import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/find_users_controller.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FindUsersPage extends HookConsumerWidget {
  const FindUsersPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final searchController = useTextEditingController();
    final findUsersController = ref.watch(
      findUsersControllerProvider(
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
            leading: IconButton(
              icon: const Icon(FluentIcons.arrow_left_24_filled),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
                child: findUsersController.when(
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
