import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
//import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../models/auth/auth.dto.dart';
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
    final fromApprentice =
        ref.watch(personasControllerProvider).valueOrNull?.firstWhere(
                  (element) => element.phone == message.subject,
                  orElse: () => const PersonaDto(),
                ) ??
            const PersonaDto();


    final auth = ref.watch(authServiceProvider);

    return ColoredBox(
      color: backgroundColor ?? (isExpanded ? Colors.white : AppColors.blue07),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded
              ? null
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
                      if (message.numOfLinesDisplay == 3)
                        const Text(
                          "אירוע",
                          style: TextStyles.s18w600cShade09,
                        ),
                      if (message.numOfLinesDisplay == 3)
                        const SizedBox(height: 12),
                      if (message.numOfLinesDisplay == 3)
                        Text(
                          " בתאריך ${message.dateTime.substring(0, 10)}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                      if (message.numOfLinesDisplay == 3)
                        const SizedBox(height: 12),
                      if (message.numOfLinesDisplay == 3)
                        Text(
                          "${message.event} ל${fromApprentice.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                 if (auth.valueOrNull?.role == UserRole.melave) ...[

                      if (message.numOfLinesDisplay == 2)
                        Text(
                          "הגיע הזמן ל${message.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                      if (message.numOfLinesDisplay == 2)
                        const SizedBox(height: 12),
                      if (message.numOfLinesDisplay == 2 &&
                          message.event == "פגישה פיזית")
                        Text(
                          " עברו ${message.daysfromnow} ימים מה${message.event}  האחרון של ${fromApprentice.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                      if (message.numOfLinesDisplay == 2 &&
                          message.event == "מפגש קבוצתי")
                        Text(
                          " עברו ${message.daysfromnow} ימים מה${message.event}  האחרון  ${fromApprentice.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),
                      if (message.numOfLinesDisplay == 2 &&
                          message.event == "שיחה טלפונית")
                        Text(
                          " עברו ${message.daysfromnow} ימים מה${message.event}  האחרונה ל${fromApprentice.fullName}",
                          style: TextStyles.s16w400cGrey2,
                        ),],
                  if (auth.valueOrNull?.role == UserRole.rakazMosad) ...[
     if (message.numOfLinesDisplay == 2 &&(message.event=="הכנסת מחזור חדש"||message.event=="דוח דו שבועי-חניכים נשכחים"||message.event=="דוח  חודשי- ציון מלווים"))
                        Text(
                          " ${message.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                      if (message.numOfLinesDisplay == 2 &&(message.event=="מפגש מלווים מקצועי"||message.event=="עשיה לטובת בוגרים"))
                        Text(
                          "הגיע הזמן ל${message.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                     if (message.numOfLinesDisplay == 2 &&message.event=="ישיבת מצב”ר")
                        Text(
                          "הגיע הזמן ל${message.event}",
                          style: TextStyles.s18w600cShade09,
                        ),
                     ]
                   
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      message.dateTime.asDateTime.asTimeAgo,
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
