import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/primary/pages/messages/controller/messages_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/badges/unread_count_badge_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigationWidget extends ConsumerWidget {
  const BottomNavigationWidget({
    super.key,
    required this.navShell,
  });

  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

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
          backgroundColor: AppColors.scaffoldBottomNavBackgroundColor,
          currentIndex: navShell.currentIndex,
          onTap: (value) => navShell.goBranch(value, initialLocation: true),
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
            const BottomNavigationBarItem(
              icon: _ClipboardTaskIconWidget(),
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
            const BottomNavigationBarItem(
              icon: _MailIconWidget(),
              label: 'הודעות',
            ),
            if (auth.isLoading)
              const BottomNavigationBarItem(
                activeIcon: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator.adaptive(),
                ),
                icon: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator.adaptive(),
                ),
                label: 'loading',
              )
            else if (auth.valueOrNull?.role == UserRole.melave)
              const BottomNavigationBarItem(
                activeIcon: Icon(FluentIcons.person_24_regular),
                icon: Icon(FluentIcons.person_24_regular),
                label: 'חניכים',
              )
            else
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

class _ClipboardTaskIconWidget extends ConsumerWidget {
  const _ClipboardTaskIconWidget();

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(tasksControllerProvider).when(
          loading: () => const UnreadCounterBadgeWidget(
            isLoading: true,
            child: Icon(FluentIcons.clipboard_task_24_regular),
          ),
          error: (error, stack) =>
              const Icon(FluentIcons.clipboard_task_24_regular),
          data: (tasks) => UnreadCounterBadgeWidget(
            count: tasks
                .where(
                  (element) => element.status == TaskStatus.todo,
                )
                .length,
            child: const Icon(FluentIcons.clipboard_task_24_regular),
          ),
        );
  }
}

class _MailIconWidget extends ConsumerWidget {
  const _MailIconWidget();

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();

    return ref.watch(messagesControllerProvider).when(
          loading: () => const UnreadCounterBadgeWidget(
            isLoading: true,
            child: Icon(FluentIcons.mail_24_regular),
          ),
          error: (error, stack) => const Icon(FluentIcons.mail_24_regular),
          data: (messages) => UnreadCounterBadgeWidget(
            count: messages
                .where(
                  (element) =>
                      !element.allreadyRead && auth.role.isProgramDirector
                          ? element.type == MessageType.customerService
                          : element.type == MessageType.incoming,
                )
                .length,
            child: const Icon(FluentIcons.mail_24_regular),
          ),
        );
  }
}
