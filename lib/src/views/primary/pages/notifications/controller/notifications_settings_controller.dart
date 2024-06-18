import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/notification/notification_settings.dto.dart';
import 'package:hadar_program/src/services/api/notification/get_notifications_settings.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'notifications_settings_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
    StorageService,
    GetNotificationsSettings,
  ],
)
class NotificationsSettingsController
    extends _$NotificationsSettingsController {
  @override
  Future<NotificationSettingsDto> build() async {
    final notifSettings =
        await ref.watch(getNotificationsSettingsProvider.future);

    return notifSettings;
  }

  Future<bool> edit({
    required NotificationSettingsDto settings,
  }) async {
    Toaster.isLoading(true);

    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.setNotificationsSettings,
        data: {
          'userId': ref.read(storageServiceProvider.notifier).getUserPhone(),
          ...settings.toJson().map(
                (key, value) => MapEntry(key, value.toString()),
              ),
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getNotificationsSettingsProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to edit notification settings', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    } finally {
      Toaster.isLoading(false);
    }

    return false;
  }
}
