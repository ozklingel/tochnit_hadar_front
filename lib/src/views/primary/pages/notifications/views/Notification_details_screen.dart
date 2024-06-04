import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationDetailsScreen extends HookConsumerWidget {
  const NotificationDetailsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final notification = ref.watch(
      notificationsControllerProvider.select(
        (val) {
          return val.value!.firstWhere(
            (element) => element.id == id,
            orElse: () => const NotificationDto(),
          );
        },
      ),
    );

    useEffect(
      () {
        ref
            .read(notificationsControllerProvider.notifier)
            .setToReadStatus(notification);

        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'פרטי התראה',
          style: TextStyles.s22w400cGrey2,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: const Text('מחיקה'),
                onTap: () async {
                  final navContext = Navigator.of(context);

                  final result = await ref
                      .read(notificationsControllerProvider.notifier)
                      .deleteNotification(notification.id);

                  if (result) {
                    navContext.pop();
                  }
                },
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  notification.event,
                  style: TextStyles.s18w500cGray2,
                ),
                const Spacer(),
                Text(
                  notification.dateTime.asDateTime.asTimeAgoDayCutoff,
                  style: TextStyles.s12w400cGrey5fRoboto,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'בתאריך '
              '${notification.dateTime.asDateTime.asDayMonthYearShortDot}',
              style: TextStyles.s14w400cGrey2,
            ),
            const SizedBox(height: 16),
            Text(
              notification.description,
            ),
          ],
        ),
      ),
    );
  }
}
