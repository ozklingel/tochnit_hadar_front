import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
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
        child: Stack(
          children: [
            BottomNavigationBar(
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
                const BottomNavigationBarItem(
                  activeIcon: Icon(FluentIcons.clipboard_task_24_regular),
                  icon: Icon(FluentIcons.clipboard_task_24_regular),
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
                  activeIcon: Icon(FluentIcons.mail_24_regular),
                  icon: Icon(FluentIcons.mail_24_regular),
                  label: 'הודעות',
                ),
                if (user.role == UserRole.melave)
                  const BottomNavigationBarItem(
                    activeIcon: Icon(FluentIcons.person_24_regular),
                    icon: Icon(FluentIcons.person_24_regular),
                    label: 'חניכים',
                  )
                else if (user.role == UserRole.ahraiTohnit)
                  const BottomNavigationBarItem(
                    activeIcon: Icon(FluentIcons.people_24_regular),
                    icon: Icon(FluentIcons.people_24_regular),
                    label: 'משתמשים',
                  ),
              ],
            ),
            const Align(
              alignment: Alignment(0.9, -0.8),
              child: IgnorePointer(
                child: CircleAvatar(
                  backgroundColor: AppColors.red1,
                  radius: 10,
                  child: Text(
                    '3',
                    style: TextStyles.s11w500,
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment(-0.36, -0.8),
              child: IgnorePointer(
                child: CircleAvatar(
                  backgroundColor: AppColors.red1,
                  radius: 10,
                  child: Text(
                    '3',
                    style: TextStyles.s11w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
