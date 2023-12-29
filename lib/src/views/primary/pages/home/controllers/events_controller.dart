import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class EventsController extends _$EventsController {
  @override
  Future<List<EventDto>> build() {
    return Future.value([]);
  }
}
