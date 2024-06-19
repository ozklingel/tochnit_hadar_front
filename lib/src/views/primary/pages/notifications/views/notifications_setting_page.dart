import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/notification/notification_settings.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_settings_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsSettingsScreen extends HookConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();
    final settingsController =
        ref.watch(notificationsSettingsControllerProvider);
    final settings =
        settingsController.valueOrNull ?? const NotificationSettingsDto();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ניהול התראות'),
      ),
      body: Padding(
        padding: Consts.defaultBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              auth.role.isAhraiTohnit
                  ? 'הגדרת זמני קבלת התראות על אירועים'
                  : 'הגדרת זמני קבלת ההתראות על אירועים (ימי הולדת ואירועים אישיים של החניך)',
              style: TextStyles.s16w400cGrey2,
            ),
            const SizedBox(height: 36),
            if (auth.role.isAhraiTohnit) ...[
              const Text(
                'משימות מתוזמנות',
                style: TextStyles.s16w500cGrey2,
              ),
              const SizedBox(height: 8),
              _Item(
                label: "בתחילת השבוע של משימה",
                isSelected: settings.notifyStartWeek,
                newSettings: settings.copyWith(
                  notifyStartWeek: !settings.notifyStartWeek,
                ),
              ),
              _Item(
                label: "יום לפני משימה",
                isSelected: settings.notifyDayBefore,
                newSettings: settings.copyWith(
                  notifyDayBefore: !settings.notifyDayBefore,
                ),
              ),
              _Item(
                label: "ביום משימה",
                isSelected: settings.notifyMorning,
                newSettings: settings.copyWith(
                  notifyMorning: !settings.notifyMorning,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ...[
              if (auth.role.isAhraiTohnit)
                const Text(
                  'תזכורת סבב מוסד',
                  style: TextStyles.s16w500cGrey2,
                ),
              const SizedBox(height: 8),
              _Item(
                label: "בתחילת השבוע של האירוע",
                isSelected: settings.notifyStartWeekSevev,
                newSettings: settings.copyWith(
                  notifyStartWeekSevev: !settings.notifyStartWeekSevev,
                ),
              ),
              _Item(
                label: "יום לפני האירוע",
                isSelected: settings.notifyDayBeforeSevev,
                newSettings: settings.copyWith(
                  notifyDayBeforeSevev: !settings.notifyDayBeforeSevev,
                ),
              ),
              _Item(
                label: "ביום האירוע",
                isSelected: settings.notifyMorningSevev,
                newSettings: settings.copyWith(
                  notifyMorningSevev: !settings.notifyMorningSevev,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  const _Item({
    required this.label,
    required this.isSelected,
    required this.newSettings,
  });

  final String label;
  final bool isSelected;
  final NotificationSettingsDto newSettings;

  @override
  Widget build(BuildContext context, ref) {
    final isLoading =
        ref.watch(notificationsSettingsControllerProvider).isLoading;

    return SwitchListTile(
      title: Text(
        label,
        style: TextStyles.s16w400cGrey2,
      ),
      trackOutlineColor: WidgetStateColor.resolveWith(
        (states) =>
            isSelected ? Colors.blue.shade700 : CupertinoColors.inactiveGray,
      ),
      trackColor: WidgetStateColor.resolveWith(
        (states) => Colors.white,
      ),
      thumbColor: WidgetStateColor.resolveWith(
        (states) =>
            isSelected ? Colors.blue.shade700 : CupertinoColors.inactiveGray,
      ),
      value: isSelected,
      onChanged: isLoading
          ? null
          : (value) => ref
              .read(
                notificationsSettingsControllerProvider.notifier,
              )
              .edit(
                settings: newSettings,
              ),
    );
  }
}
