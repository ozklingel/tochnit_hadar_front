import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';

enum YearInProgram {
  none,
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
}

enum RoleInProgram {
  none,
  all,
  rakazMosad,
  rakazim,
  melavim,
  hanihim,
}

enum StatusInProgram {
  none,
  married,
  single,
  inArmy,
  sadir,
  keva,
  released,
}

class FindGroupsPage extends HookWidget {
  const FindGroupsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedYear = useState(YearInProgram.none);
    final selectedRole = useState(RoleInProgram.none);
    final selectedStatus = useState(StatusInProgram.none);

    final years = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.a,
        onSelected: (val) => selectedYear.value == YearInProgram.a
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.a,
        label: const Text('א'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.b,
        onSelected: (val) => selectedYear.value == YearInProgram.b
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.b,
        label: const Text('ב'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.c,
        onSelected: (val) => selectedYear.value == YearInProgram.c
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.c,
        label: const Text('ג'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.d,
        onSelected: (val) => selectedYear.value == YearInProgram.d
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.d,
        label: const Text('ד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.e,
        onSelected: (val) => selectedYear.value == YearInProgram.e
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.e,
        label: const Text('ה'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.f,
        onSelected: (val) => selectedYear.value == YearInProgram.f
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.f,
        label: const Text('ו'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.g,
        onSelected: (val) => selectedYear.value == YearInProgram.g
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.g,
        label: const Text('ז'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedYear.value == YearInProgram.h,
        onSelected: (val) => selectedYear.value == YearInProgram.h
            ? selectedYear.value = YearInProgram.none
            : selectedYear.value = YearInProgram.h,
        label: const Text('ח'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final roles = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == RoleInProgram.all,
        onSelected: (val) => selectedRole.value == RoleInProgram.all
            ? selectedRole.value = RoleInProgram.none
            : selectedRole.value = RoleInProgram.all,
        label: const Text('כולם'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == RoleInProgram.rakazMosad,
        onSelected: (val) => selectedRole.value == RoleInProgram.rakazMosad
            ? selectedRole.value = RoleInProgram.none
            : selectedRole.value = RoleInProgram.rakazMosad,
        label: const Text('רכזי מוסד'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == RoleInProgram.rakazim,
        onSelected: (val) => selectedRole.value == RoleInProgram.rakazim
            ? selectedRole.value = RoleInProgram.none
            : selectedRole.value = RoleInProgram.rakazim,
        label: const Text('רכזים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == RoleInProgram.melavim,
        onSelected: (val) => selectedRole.value == RoleInProgram.melavim
            ? selectedRole.value = RoleInProgram.none
            : selectedRole.value = RoleInProgram.melavim,
        label: const Text('מלווים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedRole.value == RoleInProgram.hanihim,
        onSelected: (val) => selectedRole.value == RoleInProgram.hanihim
            ? selectedRole.value = RoleInProgram.none
            : selectedRole.value = RoleInProgram.hanihim,
        label: const Text('חניכים'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    final statuses = [
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.married,
        onSelected: (val) => selectedStatus.value == StatusInProgram.married
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.married,
        label: const Text('נשוי'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.single,
        onSelected: (val) => selectedStatus.value == StatusInProgram.single
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.single,
        label: const Text('רווק'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.inArmy,
        onSelected: (val) => selectedStatus.value == StatusInProgram.inArmy
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.inArmy,
        label: const Text('בצבא'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.sadir,
        onSelected: (val) => selectedStatus.value == StatusInProgram.sadir
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.sadir,
        label: const Text('סדיר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.keva,
        onSelected: (val) => selectedStatus.value == StatusInProgram.keva
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.keva,
        label: const Text('קבע'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
      ChoiceChip(
        showCheckmark: false,
        selectedColor: AppColors.blue06,
        selected: selectedStatus.value == StatusInProgram.released,
        onSelected: (val) => selectedStatus.value == StatusInProgram.released
            ? selectedStatus.value = StatusInProgram.none
            : selectedStatus.value = StatusInProgram.released,
        label: const Text('משוחרר'),
        labelStyle: TextStyles.s14w400cBlue2,
        side: const BorderSide(color: AppColors.blue06),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('הוספת קבוצת נמענים'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputFieldLabel(
                  label: 'תפקיד',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: roles.length,
                      itemBuilder: (ctx, idx) => roles[idx],
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'שנה בתוכנית',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: years.length,
                      itemBuilder: (ctx, idx) => years[idx],
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'שם מוסד',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: '',
                      hint: const Text('בחירת מוסד'),
                      style: TextStyles.s16w400cGrey5,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'מחזור בישיבה / מכינה',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'אשכול',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'סטטוס',
                  labelStyle: TextStyles.s16w400cGrey2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: statuses.length,
                      itemBuilder: (ctx, idx) => statuses[idx],
                      separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'בסיס',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'חטיבה',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'אזור מגורים',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                InputFieldLabel(
                  label: 'יישוב /עיר מגורים',
                  labelStyle: TextStyles.s16w400cGrey2,
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: LargeFilledRoundedButton(
                        label: 'הבא',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (val) {
                              return const _SelectedUsersPage();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: LargeFilledRoundedButton.cancel(
                        label: 'ביטול',
                        onPressed: () => Toaster.unimplemented(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedUsersPage extends StatelessWidget {
  const _SelectedUsersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('נמענים שנבחרו'),
          actions: const [
            CloseButton(),
            SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ColoredBox(
                color: Colors.white,
                child: Text(
                  'סה”כ 127',
                  style: TextStyles.s14w300cGray5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: List.generate(
                    33,
                    (index) => CheckboxListTile(
                      value: Random().nextBool(),
                      title: const Text('name'),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppColors.blue03;
                        }

                        return null;
                      }),
                      onChanged: (val) => Toaster.unimplemented(),
                    ),
                  ),
                ),
              ),
              ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: LargeFilledRoundedButton(
                            label: 'אישור',
                            onPressed: () => Toaster.unimplemented(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LargeFilledRoundedButton.cancel(
                            label: 'הקודם',
                            onPressed: () => Toaster.unimplemented(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
