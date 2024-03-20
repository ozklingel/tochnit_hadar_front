import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_controller.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/views/widgets/notification_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class NotificationDetailsScreen extends HookConsumerWidget {
  const NotificationDetailsScreen({
    super.key,
    required this.messageId,
  });

  final String messageId;

  @override
  Widget build(BuildContext context, ref) {

    final message = ref.watch(
      notificationsControllerProvider.select(
        (val) {
          return val.value!.firstWhere(
            (element) => element.id == messageId,
            orElse: () => const NotificationDto(),
          );
        },
      ),
    );

    useEffect(
      () {
        if (ref.read(userServiceProvider).valueOrNull?.role ==
            UserRole.melave) {
          ref
              .read(notificationsControllerProvider.notifier)
              .setToReadStatus(message);
        }
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('פרטי התראה'),
        centerTitle: true,
      ),
        body: NotificationWidget.expanded(
        message: message,
      ),
    );
  }
}
