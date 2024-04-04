import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/apprentice/get_maps_apprentices.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'personas_controller.g.dart';

@Riverpod(
  dependencies: [
    GetMapsApprentices,
    DioService,
    GetFilteredUsers,
    GetPersonas,
  ],
)
class PersonasController extends _$PersonasController {
  var _filters = const FilterDto();

  @override
  FutureOr<List<PersonaDto>> build() async {
    final apprentices = await ref.watch(getMapsApprenticesProvider.future);

    ref.keepAlive();

    return apprentices;
  }

  FutureOr<bool> deleteApprentice(String apprenticeId) async {
    try {
      final result = await ref.read(dioServiceProvider).put(
            apprenticeId,
            data: jsonEncode({
              'typeOfSet': 'user',
              'entityId': apprenticeId,
            }),
          );

      if (result.data['result'] == 'sucess') {
        return true;
      }
    } catch (e) {
      Sentry.captureException(e);
    }

    return false;
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
          orElse: () => const PersonaDto(),
        ) ??
        const PersonaDto();

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
          orElse: () => const PersonaDto(),
        ) ??
        const PersonaDto();

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
          orElse: () => const PersonaDto(),
        ) ??
        const PersonaDto();

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

  FutureOr<bool> edit({
    required PersonaDto persona,
  }) async {
    try {
      if (persona.isEmpty) {
        final err = 'empty user id in $this ';

        Sentry.captureException(err);
        Logger().e(this, error: err);

        return false;
      }

      final result = await ref.read(dioServiceProvider).put(
            Consts.updateApprentice,
            queryParameters: {
              'apprenticetId': persona.id,
            },
            data: jsonEncode({
              'avatar': persona.avatar,
              'militaryCompoundId': persona.militaryCompoundId,
              'militaryUnit': persona.militaryUnit,
              'militaryPositionNew': persona.militaryPositionNew,
              'militaryPositionOld': persona.militaryPositionOld,
            }),
          );

      if (result.data['result'] == 'success') {
        ref.invalidate(getMapsApprenticesProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to update apprentice', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  // FutureOr<bool> editApprentice({
  //   required ApprenticeDto apprentice,
  // }) {
  //   final newState = state.valueOrNull ?? [];

  //   final apprenticeIndex = newState.indexWhere(
  //     (element) => element.id == apprentice.id,
  //   );

  //   if (apprenticeIndex == -1) return false;

  //   newState[apprenticeIndex] = apprentice;

  //   final oldState = state.valueOrNull ?? [];

  //   state = AsyncData([...newState]);

  //   return Future.delayed(const Duration(milliseconds: 200)).then((_) {
  //     if (faker.randomGenerator.boolean()) {
  //       return true;
  //     }

  //     state = AsyncData([...oldState]);

  //     return false;
  //   });
  // }

  FutureOr<bool> filterUsers(FilterDto filter) async {
    _filters = filter;

    if (_filters.isEmpty) {
      ref.invalidateSelf();

      return true;
    }

    try {
      final request = await ref.read(getFilteredUsersProvider(_filters).future);

      state = AsyncData(
        state.requireValue
            .where((element) => request.contains(element.id))
            .toList(),
      );

      return true;
    } catch (e) {
      Logger().e('failed to filter users', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
