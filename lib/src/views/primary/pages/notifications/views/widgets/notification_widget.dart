import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';

class notificationWidget extends StatelessWidget {
  const notificationWidget.collapsed({
    super.key,
    required this.notification,
  }) : isExpanded = false;

  const notificationWidget.expanded({
    super.key,
    required this.notification,
  }) : isExpanded = true;

  final NotiDto notification;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isExpanded ? Colors.white : AppColors.blue08,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded ? null : () => notificationRouteData().go(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 246,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.from.fullName,
                        style: TextStyles.s18w600cShade09,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        notification.title,
                        style: TextStyles.s16w400cGrey2,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        notification.content,
                        maxLines: isExpanded ? null : 1,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                        style: TextStyles.s16w400cGrey2,
                      ),
                      if (notification.attachments.isNotEmpty) ...[
                        if (isExpanded) const SizedBox(height: 16),
                        Chip(
                          padding: const EdgeInsets.all(4),
                          avatar: const Padding(
                            padding: EdgeInsets.only(
                              right: 10,
                              bottom: 16,
                            ),
                            child: Icon(
                              FluentIcons.image_16_regular,
                            ),
                          ),
                          label: Text(notification.attachments.first),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  notification.dateTime.asDateTime.asTimeAgo,
                  style: TextStyles.s12w400cGrey5fRoboto,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
