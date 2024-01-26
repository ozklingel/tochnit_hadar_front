import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigationWidget extends ConsumerWidget {
  const BottomNavigationWidget({
    super.key,
    required this.navShell,
  });

  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: BottomNavigationBar(
          backgroundColor: AppColors.scafooldBottomNavBackgroundColor,
          currentIndex: navShell.currentIndex,
          onTap: (value) => navShell.goBranch(value),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.blue03,
          selectedLabelStyle: TextStyles.s12w500.copyWith(
            color: AppColors.blue03,
          ),
          unselectedItemColor: AppColors.grey3,
          unselectedLabelStyle: TextStyles.bodyB1.copyWith(
            color: AppColors.grey3,
          ),
          items: [
            BottomNavigationBarItem(
              activeIcon: const Icon(FluentIcons.clipboard_task_24_regular),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(FluentIcons.clipboard_task_24_regular),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: ref.watch(tasksControllerProvider).when(
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (error, stack) => const SizedBox(),
                          data: (tasks) => _UnreadCountBadge(
                            count: tasks
                                .where(
                                  (element) =>
                                      element.status == TaskStatus.todo,
                                )
                                .length,
                          ),
                        ),
                  ),
                ],
              ),
              label: 'משימות',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(FluentIcons.checkmark_circle_24_regular),
              icon: Icon(FluentIcons.checkmark_circle_24_regular),
              label: 'דיווחים',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(FluentIcons.home_24_regular),
              icon: Icon(FluentIcons.home_24_regular),
              label: 'בית',
            ),
            BottomNavigationBarItem(
              activeIcon: const Icon(FluentIcons.mail_24_regular),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(FluentIcons.mail_24_regular),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: ref.watch(messagesControllerProvider).when(
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (error, stack) => const SizedBox(),
                          data: (messages) => _UnreadCountBadge(
                            count: messages
                                .where((element) => !element.allreadyRead)
                                .length,
                          ),
                        ),
                  ),
                ],
              ),
              label: 'הודעות',
            ),
            if (user.valueOrNull?.role == UserRole.melave)
              const BottomNavigationBarItem(
                activeIcon: Icon(FluentIcons.person_24_regular),
                icon: Icon(FluentIcons.person_24_regular),
                label: 'חניכים',
              )
            else if (user.valueOrNull?.role == UserRole.ahraiTohnit)
              const BottomNavigationBarItem(
                activeIcon: Icon(FluentIcons.people_24_regular),
                icon: Icon(FluentIcons.people_24_regular),
                label: 'משתמשים',
              ),
          ],
        ),
      ),
    );
  }
}

class _UnreadCountBadge extends StatelessWidget {
  const _UnreadCountBadge({
    super.key,
    this.count = 0,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count < 1) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CircleAvatar(
        backgroundColor: AppColors.red1,
        radius: 9,
        child: Text(
          count.toString(),
          style: TextStyles.s11w500fRoboto,
        ),
      ),
    );
  }
}
