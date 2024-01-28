import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.text,
    required this.isSearchOpen,
    required this.controller,
    required this.actions,
    this.bottom,
  });

  final String text;
  final ValueNotifier<bool> isSearchOpen;
  final TextEditingController controller;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: AnimatedSwitcher(
        duration: Consts.defaultDurationM,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        ),
        child: isSearchOpen.value
            ? SearchBar(
                controller: controller,
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(AppColors.blue07),
                hintText: 'חיפוש...',
                leading: IconButton(
                  onPressed: () => isSearchOpen.value = false,
                  icon: const Icon(
                    FluentIcons.arrow_left_24_regular,
                    color: AppColors.gray2,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyles.s22w400cGrey2,
              ),
      ),
      actions: isSearchOpen.value ? [] : actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
