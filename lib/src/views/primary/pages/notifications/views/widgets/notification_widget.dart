import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({
    super.key,
    required this.task,
    this.hasIcon = false,
    this.backgroundColor,
  });

  final TaskDto task;
  final bool hasIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    late final String subjectName;
    try {
      subjectName = task.details.split("עם ")[1];
    } catch (e) {
      subjectName = "חניך";
    }

    final eventName = task.event.name;
    final daysFromNow = task.dateTime.asDateTime.difference(DateTime.now());

    return ColoredBox(
      color: backgroundColor ??
          (task.alreadyRead ? Colors.white : AppColors.blue07),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => NotificationDetailsRouteData(id: task.id).go(context),
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
                      if (!(eventName.contains("דוח") ||
                          eventName.contains("עידכון") ||
                          eventName.contains("הולדת") ||
                          eventName.contains("אירוע"))) ...[
                        Text(
                          "הגיע הזמן ל$eventName",
                          style: TextStyles.s18w600cShade09,
                        ),
                        const SizedBox(height: 12),
                        if (eventName == "מפגש קבוצתי" ||
                            eventName == "ביקור בבסיס" ||
                            eventName == "ישיבה מוסדית" ||
                            eventName == "ישיבת מצב”ר" ||
                            eventName == "עשיה לטובת בוגרים")
                          Text(
                            " עברו ${daysFromNow.inDays} ימים מה$eventName  האחרון  ",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (eventName == "שיחה טלפונית" ||
                            eventName == "פגישה פיזית")
                          Text(
                            " עברו ${daysFromNow.inDays} ימים מה$eventName  האחרונה ל$subjectName",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (eventName == "1פגישה פיזית")
                          Text(
                            " עברו ${daysFromNow.inDays} ימים מה$eventName  האחרון של $subjectName",
                            style: TextStyles.s16w400cGrey2,
                          ),
                      ],
                      if ((eventName.contains("דוח") ||
                          eventName.contains("עידכון"))) ...[
                        Text(
                          " $eventName",
                          style: TextStyles.s18w600cShade09,
                        ),
                      ],
                      if (eventName.contains("הולדת") ||
                          eventName.contains("אירוע")) ...[
                        const Text(
                          "אירוע",
                          style: TextStyles.s18w600cShade09,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          " בתאריך ${task.dateTime.asDateTime.asDayMonthYearShortDot}",
                          style: TextStyles.s14w400cGrey4,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "$eventName ל${auth.valueOrNull!.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      task.dateTime.asDateTime.asTimeAgoDayCutoff,
                      style: TextStyles.s12w400cGrey5fRoboto,
                    ),
                    if (task.dateTime.asDateTime.difference(DateTime.now()) >
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
