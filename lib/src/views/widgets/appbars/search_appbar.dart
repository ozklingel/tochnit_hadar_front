import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.title,
    required this.isSearchOpen,
    required this.controller,
    required this.actions,
    this.bottom,
  });

  final Widget title;
  final ValueNotifier<bool> isSearchOpen;
  final TextEditingController controller;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
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
                trailing: controller.text.isEmpty
                    ? null
                    : [
                        IconButton(
                          onPressed: () => controller.clear(),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.gray2,
                          ),
                        ),
                      ],
              )
            : title,
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        14 + (kToolbarHeight + (bottom == null ? 0 : kToolbarHeight)),
      );
}
