import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/notification/notification_settings.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_settings_controller.dart';
import 'package:hadar_program/src/views/widgets/states/loading_state.dart';
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

    if (settingsController.isLoading) {
      return const LoadingState();
    }

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
              auth.role.isProgramDirector
                  ? 'הגדרת זמני קבלת התראות על אירועים'
                  : 'הגדרת זמני קבלת ההתראות על אירועים (ימי הולדת ואירועים אישיים של החניך)',
              style: TextStyles.s16w400cGrey2,
            ),
            const SizedBox(height: 36),
            if (auth.role == UserRole.ahraiTohnit) ...[
              const Text(
                'משימות מתוזמנות',
                style: TextStyles.s16w500cGrey2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "בתחילת השבוע של משימה ",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyStartWeek
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyStartWeek,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyStartWeek
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (value) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyStartWeek: !settings.notifyStartWeek,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "יום לפני משימה",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyDayBefore
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyDayBefore,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyDayBefore
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyDayBefore: !settings.notifyDayBefore,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      " ביום משימה",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyMorning
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyMorning,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyMorning
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyMorning: !settings.notifyMorning,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
            ],
            ...[
              if (auth.role.isProgramDirector)
                const Text(
                  'תזכורת סבב מוסד',
                  style: TextStyles.s16w500cGrey2,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "בתחילת השבוע של האירוע ",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyStartWeekSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyStartWeekSevev,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyStartWeekSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyStartWeekSevev:
                                  !settings.notifyStartWeekSevev,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "יום לפני האירוע",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyDayBeforeSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyDayBeforeSevev,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyDayBeforeSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyDayBeforeSevev:
                                  !settings.notifyDayBeforeSevev,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      " ביום האירוע",
                      style: TextStyles.s16w400cGrey2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: settings.notifyMorningSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: settings.notifyMorningSevev,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: settings.notifyMorningSevev
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => ref
                          .read(
                            notificationsSettingsControllerProvider.notifier,
                          )
                          .edit(
                            settings: settings.copyWith(
                              notifyMorningSevev: !settings.notifyMorningSevev,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
