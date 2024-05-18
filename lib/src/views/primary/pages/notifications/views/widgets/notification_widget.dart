import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
//import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../models/notification/notification.dto.dart';
import '../../../../../../services/auth/auth_service.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget.collapsed({
    super.key,
    required this.message,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = false;

  const NotificationWidget.expanded({
    super.key,
    required this.message,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = true;

  final NotificationDto message;
  final bool isExpanded;
  final bool hasIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    List<String> subject_name=message.description.split("עם ");
    print(subject_name);
    return ColoredBox(
      color: backgroundColor ?? (isExpanded ? Colors.white : AppColors.blue07),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded
              ? () => NotificationDetailsRouteData(id: message.id).go(context)
              : () => NotificationDetailsRouteData(id: message.id).go(context),
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
                      if (message.numOfLinesDisplay == 3)...[
                        const Text(
                          "אירוע",
                          style: TextStyles.s18w600cShade09,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          " בתאריך ${message.dateTime.substring(0, 10)}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                  
                        const SizedBox(height: 12),
                     
                        Text(
                          "${message.event} ל${subject_name[1]}",
                          style: TextStyles.s16w400cGrey2,
                        )],

                        if (message.numOfLinesDisplay == 2 &&!message.event.contains("עידכון"))...[
                          Text(
                            "הגיע הזמן ל${message.event}",
                            style: TextStyles.s18w600cShade09,
                          ),
                          const SizedBox(height: 12),
                        if (message.event == "פגישה פיזית")
                          Text(
                            " עברו ${message.daysfromnow} ימים מה${message.event}  האחרונה של ${subject_name[1]}",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (message.event == "מפגש קבוצתי")
                          Text(
                            " עברו ${message.daysfromnow} ימים מה${message.event}  האחרון  ",
                            style: TextStyles.s16w400cGrey2,
                          ),
                        if (message.event == "שיחה טלפונית")
                          Text(
                            " עברו ${message.daysfromnow} ימים מה${message.event}  האחרונה ל${subject_name[1]}",
                            style: TextStyles.s16w400cGrey2,
                          ),
                      ],
                        if ( message.numOfLinesDisplay == 2 &&message.event.contains("עידכון"))...[
                          Text(
                            " ${message.event}",
                            style: TextStyles.s18w600cShade09,
                          ),
                     
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      message.dateTime.asDateTime.asTimeAgoDayCutoff,
                      style: TextStyles.s12w400cGrey5fRoboto,
                    ),
                    if (message.dateTime.asDateTime.difference(DateTime.now()) >
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
