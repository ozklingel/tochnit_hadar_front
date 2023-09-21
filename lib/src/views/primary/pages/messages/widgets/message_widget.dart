import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:timeago/timeago.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget.collapsed({
    super.key,
    required this.message,
  }) : isExpanded = false;

  const MessageWidget.expanded({
    super.key,
    required this.message,
  }) : isExpanded = true;

  final MessageDto message;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isExpanded ? Colors.white : AppColors.blue08,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded
              ? null
              : () => MessageDetailsRouteData(id: message.id).go(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${message.from.firstName} ${message.from.lastName}',
                        style: TextStyles.messageTitle,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        message.title,
                        style: TextStyles.bodyB3,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        message.content,
                        maxLines: isExpanded ? null : 1,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                        style: TextStyles.bodyB3,
                      ),
                      if (message.attachments.isNotEmpty) ...[
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
                          label: Text(message.attachments.first),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  format(
                    message.dateTime.asDateTime,
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                  style: TextStyles.aospBodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
