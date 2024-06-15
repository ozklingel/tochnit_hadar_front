import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../../services/auth/auth_service.dart';
import '../../../../../services/networking/http_service.dart';
import '../../../../../services/routing/go_router_provider.dart';

class NotificationsSettingsPage extends StatefulHookConsumerWidget {
  const NotificationsSettingsPage({super.key});

  @override
  ConsumerState<NotificationsSettingsPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<NotificationsSettingsPage> {
  bool t1 = false;
  bool t2 = false;
  bool t3 = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final auth = ref.watch(authServiceProvider);

    final jsonData =
        await HttpService.getUserNotiSetting(auth.valueOrNull!.phone);
    final u = jsonDecode(jsonData.body);

    // Logger().d(u);

    super.setState(() {
      t1 = !u["notifyStartWeek"];
      t2 = !u["notifyDayBefore"];
      t3 = !u["notifyMorning"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider).valueOrNull ?? const AuthDto();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => {
            HttpService.setSetting(auth.phone, !t1, !t2, !t3),
            const NotificationRouteData().go(context),
          },
        ),
        title: const Text('ניהול התראות'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              auth.role.isProgramDirector
                  ? 'הגדרת זמני קבלת התראות על אירועים'
                  : 'הגדרת זמני קבלת ההתראות על אירועים  (ימי הולדת ואירועים אישיים של החניך)',
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
                      color: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t1,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t1
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        Logger().d(t1.toString());
                        t1 = v;
                      }),
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
                      color: t2
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t2,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t2
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        t2 = v;
                      }),
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
                      color: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t3,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        t3 = v;
                      }),
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
                      color: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t1,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t1
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        Logger().d(t1.toString());
                        t1 = v;
                      }),
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
                      color: t2
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t2,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t2
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        t2 = v;
                      }),
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
                      color: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                    ),
                    child: CupertinoSwitch(
                      value: t3,
                      activeColor: CupertinoColors.white,
                      trackColor: CupertinoColors.white,
                      thumbColor: t3
                          ? Colors.blue.shade700
                          : CupertinoColors.inactiveGray,
                      onChanged: (v) => setState(() {
                        t3 = v;
                      }),
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
