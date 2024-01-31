import 'package:hadar_program/src/services/api/notification/get_all_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_controller.g.dart';

@Riverpod(
  dependencies: [
    GetAllNotifications,
  ],
)
class NotificationsController extends _$NotificationsController {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final notifications = await ref.watch(getAllNotificationsProvider.future);

    return notifications;
  }
}
