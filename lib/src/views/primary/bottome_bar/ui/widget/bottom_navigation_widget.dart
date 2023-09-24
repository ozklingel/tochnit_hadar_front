import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigationWidget extends ConsumerWidget {
  const BottomNavigationWidget({
    super.key,
    required this.navShell,
  });

  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context, ref) {
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
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.tasks_app_24_regular),
            icon: Icon(FluentIcons.tasks_app_24_regular),
            label: 'משימות',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.checkmark_circle_24_regular),
            icon: Icon(FluentIcons.checkmark_circle_24_regular),
            label: 'דיווחים',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.home_24_regular),
            icon: Icon(FluentIcons.home_24_regular),
            label: 'בית',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.mail_24_regular),
            icon: Icon(FluentIcons.mail_24_regular),
            label: 'הודעות',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.person_24_regular),
            icon: Icon(FluentIcons.person_24_regular),
            label: 'חניכים',
          ),
        ],
      ),
    );
  }
}
