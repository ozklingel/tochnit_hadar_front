import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:hadar_program/src/views/secondary/institutions/controllers/institutions_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
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
                              builder: (ctx) =>
                                  const _FiltersFullScreenDialog(),
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
                            '345 משתמשים',
                            style: TextStyles.s14w400
                                .copyWith(color: AppColors.gray5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => Toaster.unimplemented(),
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
  const _SortDialog({
    super.key,
  });

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

class _FiltersFullScreenDialog extends StatelessWidget {
  const _FiltersFullScreenDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Text('נקה סינונים', style: TextStyles.s16w300cGray2),
                Spacer(),
                CloseButton(),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'סנן משתמשים לפי',
              style: TextStyles.s22w500cGrey2,
            ),
            const _RoleSection(),
            const _YearInProgramSection(),
            const _InstitutionSection(),
            const _PeriodSection(),
            const _EshkolSection(),
            const _MaritalStatusSection(),
            const _BaseSection(),
            const _HativaSection(),
            const _LivingAreaSection(),
            const _CitySection(),
            const SizedBox(height: 48),
            LargeFilledRoundedButton(
              label: 'עדכן',
              onPressed: () => Toaster.unimplemented(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitySection extends StatelessWidget {
  const _CitySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'יישוב /עיר מגורים'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת יישוב/ עיר'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _LivingAreaSection extends StatelessWidget {
  const _LivingAreaSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'אזור מגורים'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת אזור מגורים'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _HativaSection extends StatelessWidget {
  const _HativaSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'חטיבה'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת חטיבה'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _BaseSection extends StatelessWidget {
  const _BaseSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'בסיס'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת בסיס'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _MaritalStatusSection extends StatelessWidget {
  const _MaritalStatusSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('נשוי'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('רווק'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('בצבא'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('סדיר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('קבע'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('משוחרר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'סטטוס'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (ctx, idx) => children[idx],
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}

class _EshkolSection extends StatelessWidget {
  const _EshkolSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'אשכול'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת אשכול'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodSection extends StatelessWidget {
  const _PeriodSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'מחזור בישיבה / מכינה'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בחירת מחזור'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _InstitutionSection extends StatelessWidget {
  const _InstitutionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(label: 'שם מוסד'),
        SizedBox(
          height: 42,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: '',
              hint: const Text('בני דוד עלי, נוקדים'),
              selectedItemBuilder: (context) {
                return [];
              },
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
              items: const [],
            ),
          ),
        ),
      ],
    );
  }
}

class _YearInProgramSection extends StatelessWidget {
  const _YearInProgramSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ז'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('ח'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    return Column(
      children: [
        const _Header(label: 'שנה בתוכנית'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (ctx, idx) => children[idx],
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}

class _RoleSection extends StatelessWidget {
  const _RoleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('רכזי מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('רכזים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('מלווים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        selected: false,
        onSelected: (val) => Toaster.unimplemented(),
        label: const Text('חניכים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    return Column(
      children: [
        const _Header(label: 'תפקיד'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (ctx, idx) => children[idx],
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyles.s16w400cGrey2,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
