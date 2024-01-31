import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_notifications.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetAllNotifications extends _$GetAllNotifications {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.notifications;
    }

    final request =
        await ref.watch(dioServiceProvider).get('notification_form/getAll');

    final result = (request.data as List<dynamic>)
        .map<Map<String, dynamic>>((e) => e)
        .toList();

    return result;
  }
}
