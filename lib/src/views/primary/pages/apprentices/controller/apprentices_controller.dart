import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apprentices_controller.g.dart';

@Riverpod(
  dependencies: [
    GetApprentices,
  ],
)
class ApprenticesController extends _$ApprenticesController {
  @override
  FutureOr<List<ApprenticeDto>> build() async {
    final apprentices = await ref.watch(getApprenticesProvider.future);

    return apprentices;
  }

  FutureOr<bool> addEvent({
    required String apprenticeId,
    required EventDto event,
  }) async {
    if (apprenticeId.isEmpty) {
      return false;
    }

    final apprentice = state.valueOrNull?.singleWhere(
          (element) => element.id == apprenticeId,
          orElse: () => const ApprenticeDto(),
        ) ??
        const ApprenticeDto();

    final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

    if (apprenticeIndex == -1) return false;

    final newState = state.valueOrNull ?? [];

    newState[apprenticeIndex] = apprentice.copyWith(
      events: [...apprentice.events, event],
    );

    final oldState = state.valueOrNull ?? [];

    state = AsyncData([...newState]);

    await Future.delayed(const Duration(milliseconds: 200));

    if (faker.randomGenerator.boolean()) {
      return true;
    }

    state = AsyncData([...oldState]);

    return false;
  }

  FutureOr<bool> deleteEvent({
    required String apprenticeId,
    required String eventId,
  }) async {
    final apprentice = state.valueOrNull?.singleWhere(
          (element) => element.id == apprenticeId,
          orElse: () => const ApprenticeDto(),
        ) ??
        const ApprenticeDto();

    final oldState = state.valueOrNull ?? [];

    final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

    if (apprenticeIndex == -1) return false;

    final newState = state.valueOrNull ?? [];

    final event =
        apprentice.events.firstWhere((element) => element.id == eventId);

    final newEvents = [...apprentice.events];

    final oldEventIndex = newEvents.indexOf(event);

    newEvents.removeAt(oldEventIndex);

    newState[apprenticeIndex] = apprentice.copyWith(
      events: [...newEvents],
    );

    state = AsyncData([...newState]);

    await Future.delayed(const Duration(milliseconds: 200));

    if (faker.randomGenerator.boolean()) {
      return true;
    }

    // TODO(noga-dev): if old event's date changes should it be sorted?

    newEvents.insert(oldEventIndex, event);

    oldState[apprenticeIndex] = apprentice.copyWith(
      events: [...newEvents],
    );

    state = AsyncData([...oldState]);

    return false;
  }

  FutureOr<bool> editEvent({
    required String apprenticeId,
    required EventDto event,
  }) async {
    final apprentice = state.valueOrNull?.singleWhere(
          (element) => element.id == apprenticeId,
          orElse: () => const ApprenticeDto(),
        ) ??
        const ApprenticeDto();

    final oldState = state.valueOrNull ?? [];

    final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

    if (apprenticeIndex == -1) return false;

    final newState = state.valueOrNull ?? [];

    final eventIndex = apprentice.events.indexWhere(
      (element) => element.id == event.id,
    );

    if (eventIndex == -1) return false;

    final newEventsList = [...apprentice.events];

    newEventsList.removeAt(eventIndex);
    newEventsList.insert(eventIndex, event);

    newState[apprenticeIndex] = apprentice.copyWith(
      events: [...newEventsList],
    );

    state = AsyncData([...newState]);

    await Future.delayed(const Duration(milliseconds: 200));

    if (faker.randomGenerator.boolean()) {
      return true;
    }

    oldState[apprenticeIndex] = apprentice.copyWith(
      events: [...apprentice.events],
    );

    state = AsyncData([...oldState]);

    return false;
  }

  FutureOr<bool> editApprentice({
    required ApprenticeDto apprentice,
  }) {
    final newState = state.valueOrNull ?? [];

    final apprenticeIndex = newState.indexWhere(
      (element) => element.id == apprentice.id,
    );

    if (apprenticeIndex == -1) return false;

    newState[apprenticeIndex] = apprentice;

    final oldState = state.valueOrNull ?? [];

    state = AsyncData([...newState]);

    return Future.delayed(const Duration(milliseconds: 200)).then((_) {
      if (faker.randomGenerator.boolean()) {
        return true;
      }

      state = AsyncData([...oldState]);

      return false;
    });
  }
}
