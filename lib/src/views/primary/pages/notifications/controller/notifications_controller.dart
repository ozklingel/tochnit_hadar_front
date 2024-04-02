import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/services/api/notification/get_notifications.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'notifications_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
    GetNotifications,
    GetApprentices,
  ],
)
class NotificationsController extends _$NotificationsController {
  @override
  Future<List<NotificationDto>> build() async {
    final notifications = await ref.watch(getNotificationsProvider.future);

    return notifications;
  }

  Future<bool> setToReadStatus(NotificationDto msg) async {
    if (msg.allreadyRead) {
      return true;
    }

    Logger().d(msg.id);

    try {
      await ref.read(dioServiceProvider).post(
        Consts.setNotificationWasRead,
        data: {
          'noti_id': msg.id,
        },
      );

      ref.invalidate(getNotificationsProvider);

      return true;
    } catch (e) {
      Sentry.captureException(e);

      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      final result = await ref.read(dioServiceProvider).delete(
        Consts.deleteMessage,
        data: {
          'entityId': notificationId,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidateSelf();

        return true;
      }
    } catch (e) {
      Sentry.captureException(e);
    }

    return false;
  }

  Future<List<PersonaDto>> searchApprentices(String keyword) async {
    final apprentices = await ref.read(getApprenticesProvider.future);

    final filtered = apprentices
        .where(
          (element) =>
              element.fullName.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();

    return filtered;
  }
}
