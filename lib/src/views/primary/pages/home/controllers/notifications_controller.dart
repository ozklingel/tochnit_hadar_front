import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../models/notification/notification.dto.dart';
import '../../../../../services/api/notification/get_notifications.dart';

part 'notifications_controller.g.dart';

@Riverpod(
  dependencies: [
    GetNotifications,
  ],
)
class NotificationsController extends _$NotificationsController {
  @override
  Future<List<NotificationDto>> build() async {
    final notifications = await ref.watch(getNotificationsProvider.future);

    return notifications;
  }
}
