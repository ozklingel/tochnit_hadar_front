import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageWidget extends ConsumerWidget {
  const MessageWidget.collapsed({
    super.key,
    required this.message,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = false;

  const MessageWidget.expanded({
    super.key,
    required this.message,
    this.hasIcon = false,
    this.backgroundColor,
  }) : isExpanded = true;

  final MessageDto message;
  final bool isExpanded;
  final bool hasIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, ref) {
    return ColoredBox(
      color: backgroundColor ?? (isExpanded ? Colors.white : AppColors.blue07),
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
                if (hasIcon && message.icon.isNotEmpty)
                  const Icon(FluentIcons.mail_24_regular),
                SizedBox(
                  width: 232,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.to.isEmpty ? 'N/A' : message.to.join(),
                        style: TextStyles.s18w600cShade09,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        message.title,
                        style: TextStyles.s16w400cGrey2,
                      ),
                      if (isExpanded) const SizedBox(height: 16),
                      Text(
                        message.content,
                        maxLines: isExpanded ? 2 : 1,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                        style: TextStyles.s16w400cGrey2,
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
                Column(
                  children: [
                    Text(
                      message.dateTime.asDateTime.asTimeAgoDayCutoff,
                      style: TextStyles.s12w400cGrey5fRoboto,
                    ),
                    if (DateTime.now().difference(message.dateTime.asDateTime) < const Duration(seconds: 5)) ...[
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
