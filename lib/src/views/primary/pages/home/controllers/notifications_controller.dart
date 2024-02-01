import 'package:hadar_program/src/services/api/notification/get_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_controller.g.dart';

@Riverpod(
  dependencies: [
    GetNotifications,
  ],
)
class NotificationsController extends _$NotificationsController {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final notifications = await ref.watch(getNotificationsProvider.future);

    return notifications;
  }
}
