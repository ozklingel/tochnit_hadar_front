import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_notifications.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetNotifications extends _$GetNotifications {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.notifications;
    }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllNotifications);

    final result = (request.data as List<dynamic>)
        .map<Map<String, dynamic>>((e) => e)
        .toList();

    return result;
  }
}
