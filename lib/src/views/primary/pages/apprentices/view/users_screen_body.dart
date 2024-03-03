// ignore_for_file: unused_element

import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/compound_controller.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/secondary/filter/filters_screen.dart';
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/list_tile_with_tags_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsersScreenBody extends HookConsumerWidget {
  const UsersScreenBody({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final users = ref.watch(usersControllerProvider);
    final filters = useState<List<String>>([]);
    final selectedApprenticeIds = useState<List<String>>([]);
    final compounds = ref.watch(compoundControllerProvider).valueOrNull;
    final institutions = ref.watch(institutionsControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('משתמשים'),
        actions: [
          if (selectedApprenticeIds.value.isNotEmpty) ...[
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.chat_24_regular),
            ),
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => const NewUserRouteData().push(context),
        heroTag: UniqueKey(),
        shape: const CircleBorder(),
        backgroundColor: AppColors.blue02,
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            collapsedHeight: 90,
            pinned: true,
            flexibleSpace: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: SearchBar(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => AppColors.blue08,
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              leading: const Icon(
                                FluentIcons.line_horizontal_3_20_filled,
                              ),
                              trailing: const [
                                Icon(
                                  FluentIcons.search_24_filled,
                                  size: 20,
                                ),
                              ],
                              hintText: 'חיפוש',
                              hintStyle: MaterialStateProperty.all(
                                TextStyles.s16w400cGrey2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (ctx) => const FiltersScreen.users(),
                              fullscreenDialog: true,
                            ),
                          ),
                          icon: const Icon(FluentIcons.filter_add_20_regular),
                        ),
                      ],
                    ),
                  ),
                  if (filters.value.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ListView(
                      scrollDirection: Axis.horizontal,
                      children: filters.value
                          .map(
                            (e) => FilterChip(
                              label: Text(e),
                              onSelected: (val) => Toaster.unimplemented(),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (ctx) => const _SortDialog(),
                          ),
                          icon: const Icon(
                            FluentIcons.arrow_sort_down_lines_24_regular,
                            color: AppColors.gray2,
                          ),
                          label: Text(
                            '${(users.valueOrNull ?? []).length} משתמשים',
                            style: TextStyles.s14w400
                                .copyWith(color: AppColors.gray5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            if (Platform.isAndroid || Platform.isIOS) {
                              Toaster.unimplemented();
                            } else {
                              Toaster.unimplemented();
                            }
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyles.s14w400,
                            foregroundColor: AppColors.gray1,
                          ),
                          icon: const Icon(FluentIcons.location_24_regular),
                          label: const Text('תצוגת מפה'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          users.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Text(error.toString()),
            ),
            data: (usersList) {
              return SliverList.builder(
                itemCount: usersList.length,
                itemBuilder: (ctx, idx) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTileWithTagsCard(
                    onlineStatus: usersList[idx].callStatus,
                    avatar: usersList[idx].avatar,
                    name: usersList[idx].fullName,
                    tags: [
                      usersList[idx].highSchoolInstitution,
                      usersList[idx].thPeriod,
                      usersList[idx].militaryPositionNew,
                      (institutions?.singleWhere(
                                (element) =>
                                    element.id == usersList[idx].institutionId,
                                orElse: () => const InstitutionDto(),
                              ) ??
                              const InstitutionDto())
                          .name,
                      (compounds?.singleWhere(
                                (element) =>
                                    element.id ==
                                    usersList[idx].militaryCompoundId,
                                orElse: () => const CompoundDto(),
                              ) ??
                              const CompoundDto())
                          .name,
                      usersList[idx].militaryUnit,
                      usersList[idx].maritalStatus,
                    ],
                    isSelected:
                        selectedApprenticeIds.value.contains(usersList[idx].id),
                    onLongPress: () {
                      if (selectedApprenticeIds.value
                          .contains(usersList[idx].id)) {
                        final newList = selectedApprenticeIds;
                        newList.value.remove(usersList[idx].id);
                        selectedApprenticeIds.value = [
                          ...newList.value,
                        ];
                      } else {
                        selectedApprenticeIds.value = [
                          ...selectedApprenticeIds.value,
                          usersList[idx].id,
                        ];
                      }
                    },
                    onTap: () =>
                        ApprenticeDetailsRouteData(id: usersList[idx].id)
                            .go(context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SortDialog extends StatelessWidget {
  const _SortDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 260,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'מיין לפי',
                style: TextStyles.s16w400cGrey5,
              ),
              RadioListTile.adaptive(
                value: 'abc-firstname',
                groupValue: 'abc-firstname',
                onChanged: (val) => Toaster.unimplemented(),
                title: const Text(
                  'א-ב שם פרטי',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: 'abc-lastname',
                groupValue: 'abc-firstname',
                onChanged: (val) => Toaster.unimplemented(),
                title: const Text(
                  'א-ב שם משפחה',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: 'active-to-inactive',
                groupValue: 'abc-firstname',
                onChanged: (val) => Toaster.unimplemented(),
                title: const Text(
                  'מהפעיל אל הפחות פעיל',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
              RadioListTile.adaptive(
                value: 'inactive-to-active',
                groupValue: 'abc-firstname',
                onChanged: (val) => Toaster.unimplemented(),
                title: const Text(
                  'מהפחות פעיל אל הפעיל',
                  style: TextStyles.s16w400cGrey2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
