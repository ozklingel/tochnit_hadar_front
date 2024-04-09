import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/widgets/list/persona_card_popup_menu_items.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticeAppBar extends ConsumerWidget {
  const ApprenticeAppBar({
    super.key,
    required this.isSearchOpen,
    required this.searchController,
    required this.selectedPersonas,
  });

  final ValueNotifier<bool> isSearchOpen;
  final TextEditingController searchController;
  final ValueNotifier<List<PersonaDto>> selectedPersonas;

  @override
  Widget build(BuildContext context, ref) {
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
              if (selectedPersonas.value.isEmpty)
                IconButton(
                  onPressed: () => isSearchOpen.value = true,
                  icon: const Icon(FluentIcons.search_24_regular),
                )
              else if (selectedPersonas.value.length == 1)
                PersonaCardPopupMoreVerticalWidget(
                  personas: selectedPersonas.value,
                  offset: const Offset(0, 32),
                )
              else
                IconButton(
                  onPressed: () => ReportNewRouteData(
                    initRecipients:
                        selectedPersonas.value.map((e) => e.id).toList(),
                  ).push(context),
                  icon: const Icon(FluentIcons.clipboard_task_24_regular),
                ),
              const SizedBox(width: 16),
            ],
    );
  }
}
