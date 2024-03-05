import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_closest_events.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetClosestEvents extends _$GetClosestEvents {
  @override
  Future<List<EventDto>> build() async {
    final result =
        await ref.watch(dioServiceProvider).get(Consts.getClosestEvents);

    final parsed = result.data as List<dynamic>;

    final processed = parsed.map((e) => EventDto.fromJson(e)).toList();

    ref.keepAlive();

    // Logger().d(processed);

    return processed;
  }
}
