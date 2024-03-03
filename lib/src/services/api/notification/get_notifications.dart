import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/notification/notification.dto.dart';

part 'get_notifications.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetNotifications extends _$GetNotifications {
  @override
  FutureOr<List<notificationDto>> build() async {


    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllMessages);

    final parsed = (request.data as List<dynamic>)
        .map((e) => notificationDto.fromJson(e))
        .toList();

    return parsed;
  }
}
