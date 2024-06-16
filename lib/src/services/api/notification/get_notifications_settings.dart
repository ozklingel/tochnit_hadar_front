import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/notification/notification_settings.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_notifications_settings.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetNotificationsSettings extends _$GetNotificationsSettings {
  @override
  FutureOr<NotificationSettingsDto> build() async {
    final request = await ref
        .watch(dioServiceProvider)
        .get(Consts.getNotificationsSettings);

    final parsed = NotificationSettingsDto.fromJson(request.data);

    return parsed;
  }
}
