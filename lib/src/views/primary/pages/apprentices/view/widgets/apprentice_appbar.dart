import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/view/widgets/compound_bottom_sheet.dart';

class ApprenticeAppBar extends StatelessWidget {
  const ApprenticeAppBar({
    super.key,
    required this.isSearchOpen,
    required this.searchController,
    required this.selectedIds,
    required this.apprentices,
  });

  final ValueNotifier<bool> isSearchOpen;
  final TextEditingController searchController;
  final ValueNotifier<List<String>> selectedIds;
  final List<ApprenticeDto> apprentices;

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
                controller: searchController,
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(AppColors.blue07),
                hintText: 'חיפוש',
                leading: IconButton(
                  onPressed: () {
                    isSearchOpen.value = false;
                  },
                  icon: const Icon(
                    FluentIcons.arrow_left_24_regular,
                    color: AppColors.gray2,
                  ),
                ),
                trailing: [
                  IconButton(
                    onPressed: () {
                      isSearchOpen.value = false;
                      searchController.clear();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.gray2,
                    ),
                  ),
                ],
                // decoration: InputDecoration(
                //   hintText: 'חיפוש',
                //   border: InputBorder.none,
                //   fillColor: AppColors.blue07,
                //   prefixIcon: Icon(FluentIcons.arrow_left_24_regular),
                // ),
              )
            : const Text('חניכים'),
      ),
      actions: isSearchOpen.value
          ? []
          : [
              if (selectedIds.value.isEmpty)
                IconButton(
                  onPressed: () => isSearchOpen.value = true,
                  icon: const Icon(FluentIcons.search_24_regular),
                )
              else if (selectedIds.value.length == 1)
                PopupMenuButton(
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                  surfaceTintColor: Colors.white,
                  offset: const Offset(0, 32),
                  itemBuilder: (context) => getApprenticeCardPopupItems(
                    context: context,
                    apprentice: apprentices.singleWhere(
                      (element) => element.id == selectedIds.value.first,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: () => Toaster.unimplemented(),
                  icon: const Icon(FluentIcons.clipboard_checkmark_24_regular),
                ),
              const SizedBox(width: 16),
            ],
    );
  }
}
