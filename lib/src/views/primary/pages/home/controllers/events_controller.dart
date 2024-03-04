import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/services/api/home_page/get_closest_events.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class EventsController extends _$EventsController {
  @override
  Future<List<EventDto>> build() async {
    final events = await ref.watch(getClosestEventsProvider.future);

    // Logger().d(events.length);

    return events;
  }
}
