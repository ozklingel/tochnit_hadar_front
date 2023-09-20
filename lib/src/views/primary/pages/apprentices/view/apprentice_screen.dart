import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/routing/named_route.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:hadar_program/src/views/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApprenticeScreen extends HookConsumerWidget {
  const ApprenticeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedIds = useState(<String>[]);
    final isSearchOpen = useState(false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: Consts.kDefaultDurationM,
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
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(AppColors.blue07),
                  hintText: 'חיפוש',
                  leading: IconButton(
                    onPressed: () => isSearchOpen.value = false,
                    icon: const Icon(
                      FluentIcons.arrow_left_24_regular,
                      color: AppColors.gray2,
                    ),
                  ),
                  trailing: [
                    IconButton(
                      onPressed: () => isSearchOpen.value = false,
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
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('להתקשר'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת וואטסאפ'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('שליחת SMS'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('דיווח'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                      PopupMenuItem(
                        child: const Text('פרופיל אישי'),
                        onTap: () => Toaster.unimplemented(),
                      ),
                    ],
                  )
                else
                  IconButton(
                    onPressed: () => Toaster.unimplemented(),
                    icon:
                        const Icon(FluentIcons.clipboard_checkmark_24_regular),
                  ),
                const SizedBox(width: 16),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => Toaster.unimplemented(),
                style: TextButton.styleFrom(
                  textStyle: TextStyles.bodyB3Bold,
                  foregroundColor: AppColors.blue03,
                ),
                label: const Icon(FluentIcons.location_24_regular),
                icon: const Text('תצוגת מפה'),
              ),
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () =>
                    ref.refresh(apprenticesControllerProvider.future),
                child: ref.watch(apprenticesControllerProvider).when(
                      loading: () => const LoadingWidget(),
                      error: (error, stack) => const SizedBox(),
                      data: (apprentices) {
                        final children = apprentices
                            .map(
                              (e) => DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimatedContainer(
                                    duration: Consts.kDefaultDurationM,
                                    decoration: BoxDecoration(
                                      color: selectedIds.value.contains(e.id)
                                          ? AppColors.blue08
                                          : Colors.white,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () =>
                                          ref.read(goRouterProvider).push(
                                                '${Routes.apprentice}/${Routes.apprenticeDetails}/${e.id}',
                                              ),
                                      onLongPress: () {
                                        if (selectedIds.value.contains(e.id)) {
                                          final newList = selectedIds;
                                          newList.value.remove(e.id);
                                          selectedIds.value = [
                                            ...newList.value,
                                          ];
                                        } else {
                                          selectedIds.value = [
                                            ...selectedIds.value,
                                            e.id,
                                          ];
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            if (e.avatar.isEmpty)
                                              const CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    AppColors.grey6,
                                                child: Icon(
                                                  FluentIcons.person_24_filled,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              )
                                            else
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  e.avatar,
                                                ),
                                              ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${e.firstName} ${e.lastName}',
                                                  style:
                                                      TextStyles.apprenticeName,
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                    Random().nextBool()
                                                        ? 'בני דוד עלי'
                                                            ' • '
                                                            'מחזור ג'
                                                            ' • '
                                                            'סדיר'
                                                            ' • '
                                                            'גבעתי'
                                                            ' • '
                                                            'צאלים'
                                                            ' • '
                                                            'רווק'
                                                        : 'סדיר'
                                                            ' • '
                                                            'גבעתי'
                                                            ' • '
                                                            'צאלים'
                                                            ' • '
                                                            'חטמר שומרון'
                                                            ' • '
                                                            'רווק'
                                                            ' • '
                                                            'בני דוד עלי'
                                                            ' • '
                                                            'מחזור ג'
                                                            ' • ',
                                                    style: TextStyles.bodyB1Bold
                                                        .copyWith(
                                                      color: AppColors.blue03,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList();

                        return ListView.separated(
                          itemCount: apprentices.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) => children[index],
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
