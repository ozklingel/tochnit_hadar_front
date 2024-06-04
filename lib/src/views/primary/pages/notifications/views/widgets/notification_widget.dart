import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget.collapsed({
    super.key,
    required this.notification,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = false;

  const NotificationWidget.expanded({
    super.key,
    required this.notification,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = true;

  final NotificationDto notification;
  final bool isExpanded;
  final bool hasIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    List<String> subjectName = notification.description.split("עם ");

    return ColoredBox(
      color: backgroundColor ?? (isExpanded ? Colors.white : AppColors.blue07),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded
              ? () =>
                  NotificationDetailsRouteData(id: notification.id).go(context)
              : () =>
                  NotificationDetailsRouteData(id: notification.id).go(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 232,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!(notification.event.contains("דוח") ||
                          notification.event.contains("עידכון") ||
                          notification.event.contains("הולדת") ||
                          notification.event.contains("אירוע"))) ...[
                        Text(
                          "הגיע הזמן ל${notification.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                        const SizedBox(height: 12),
                        if (notification.event == "מפגש קבוצתי" ||
                            notification.event == "ביקור בבסיס" ||
                            notification.event == "ישיבה מוסדית" ||
                            notification.event == "ישיבת מצב”ר" ||
                            notification.event == "עשיה לטובת בוגרים")
                          Text(
                            " עברו ${notification.daysfromnow} ימים מה${notification.event}  האחרון  ",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (notification.event == "שיחה טלפונית" ||
                            notification.event == "פגישה פיזית")
                          Text(
                            " עברו ${notification.daysfromnow} ימים מה${notification.event}  האחרונה ל${subjectName[1]}",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (notification.event == "1פגישה פיזית")
                          Text(
                            " עברו ${notification.daysfromnow} ימים מה${notification.event}  האחרון של ${subjectName[1]}",
                            style: TextStyles.s16w400cGrey2,
                          ),
                      ],
                      if ((notification.event.contains("דוח") ||
                          notification.event.contains("עידכון"))) ...[
                        Text(
                          " ${notification.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                      ],
                      if (notification.event.contains("הולדת") ||
                          notification.event.contains("אירוע")) ...[
                        const Text(
                          "אירוע",
                          style: TextStyles.s18w600cShade09,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          " בתאריך ${notification.dateTime.substring(0, 10)}",
                          style: TextStyles.s14w400cGrey4,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "${notification.event} ל${auth.valueOrNull!.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      notification.dateTime.asDateTime.asTimeAgoDayCutoff,
                      style: TextStyles.s12w400cGrey5fRoboto,
                    ),
                    if (notification.dateTime.asDateTime
                            .difference(DateTime.now()) >
                        Duration.zero) ...[
                      const SizedBox(height: 12),
                      const Icon(
                        FluentIcons.clock_24_regular,
                        color: AppColors.gray6,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
