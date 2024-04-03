import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/models/personas_screen.dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'users_controller.g.dart';

enum Sort {
  a2zByFirstName,
  a2zByLastName,
  // z2aByFirstName,
  // z2aByLastName,
  activeToInactive,
  inactiveToActive,
}

@Riverpod(
  dependencies: [
    GetPersonas,
    GoRouterService,
    DioService,
  ],
)
class UsersController extends _$UsersController {
  @override
  FutureOr<PersonasScreenDto> build() async {
    final apprentices = await ref.watch(getPersonasProvider.future);

    return PersonasScreenDto(
      users: apprentices,
    );
  }

  void mapView(bool isMapOpen) {
    state = AsyncData(
      state.requireValue.copyWith(
        isMapOpen: isMapOpen,
      ),
    );
  }

  void sort(Sort sort) {
    switch (sort) {
      case Sort.a2zByFirstName:
        state = AsyncData(
          state.requireValue.copyWith(
            users: state.requireValue.users
                .sortedBy((element) => element.firstName),
          ),
        );
        break;
      case Sort.a2zByLastName:
        state = AsyncData(
          state.requireValue.copyWith(
            users: state.requireValue.users
                .sortedBy((element) => element.lastName),
          ),
        );
        break;
      case Sort.activeToInactive:
        state = AsyncData(
          state.requireValue.copyWith(
            users: state.requireValue.users
                .sortedBy<num>((element) => element.activityScore),
          ),
        );
      case Sort.inactiveToActive:
        state = AsyncData(
          state.requireValue.copyWith(
            users: state.requireValue.users.reversed.toList(),
          ),
        );
        break;
    }
  }

  Future<bool> createManual({
    required UserRole role,
    required String institutionId,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
            Consts.addUserManual,
            data: jsonEncode({
              'role_id': role.val.toString(),
              'institution_id': institutionId,
              'phone': phone,
              'first_name': firstName,
              'last_name': lastName,
            }),
          );

      if (result.data['result'] == 'success') {
        ref.invalidate(getPersonasProvider);

        ref.read(goRouterServiceProvider).go('/personas');

        return true;
      }
    } catch (e) {
      Logger().e('failed to add user manual', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> createExcel({
    required PlatformFile file,
  }) async {
    try {
      if (file.bytes == null) {
        throw ArgumentError('missing param bytes');
      }

      final result = await ref.read(dioServiceProvider).post(
            Consts.addUserExcel,
            data: FormData.fromMap({
              'file': MultipartFile.fromBytes(
                file.bytes!.toList(),
                filename: file.path,
                contentType: MediaType.parse('multipart/form-data'),
              ),
            }),
          );

      if (result.data['result'] == 'success') {
        ref.invalidate(getPersonasProvider);

        ref.read(goRouterServiceProvider).go('/personas');

        return true;
      }
    } catch (e) {
      Logger().e('failed to add user excel', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  // Future<bool> addUser() {}

  // FutureOr<bool> addEvent({
  //   required String apprenticeId,
  //   required EventDto event,
  // }) async {
  //   if (apprenticeId.isEmpty) {
  //     return false;
  //   }

  //   // unnecessarily complex jsut

  //   final apprentice = state.valueOrNull?.singleWhere(
  //         (element) => element.id == apprenticeId,
  //         orElse: () => const ApprenticeDto(),
  //       ) ??
  //       const ApprenticeDto();

  //   final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

  //   if (apprenticeIndex == -1) return false;

  //   final newState = state.valueOrNull ?? [];

  //   newState[apprenticeIndex] = apprentice.copyWith(
  //     events: [...apprentice.events, event],
  //   );

  //   final oldState = state.valueOrNull ?? [];

  //   state = AsyncData([...newState]);

  //   await Future.delayed(const Duration(milliseconds: 200));

  //   if (faker.randomGenerator.boolean()) {
  //     return true;
  //   }

  //   state = AsyncData([...oldState]);

  //   return false;
  // }

  // FutureOr<bool> deleteEvent({
  //   required String apprenticeId,
  //   required String eventId,
  // }) async {
  //   final apprentice = state.valueOrNull?.singleWhere(
  //         (element) => element.id == apprenticeId,
  //         orElse: () => const ApprenticeDto(),
  //       ) ??
  //       const ApprenticeDto();

  //   final oldState = state.valueOrNull ?? [];

  //   final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

  //   if (apprenticeIndex == -1) return false;

  //   final newState = state.valueOrNull ?? [];

  //   final event =
  //       apprentice.events.firstWhere((element) => element.id == eventId);

  //   final newEvents = [...apprentice.events];

  //   final oldEventIndex = newEvents.indexOf(event);

  //   newEvents.removeAt(oldEventIndex);

  //   newState[apprenticeIndex] = apprentice.copyWith(
  //     events: [...newEvents],
  //   );

  //   state = AsyncData([...newState]);

  //   await Future.delayed(const Duration(milliseconds: 200));

  //   if (faker.randomGenerator.boolean()) {
  //     return true;
  //   }

  //   // TODO(noga-dev): if old event's date changes should it be sorted?

  //   newEvents.insert(oldEventIndex, event);

  //   oldState[apprenticeIndex] = apprentice.copyWith(
  //     events: [...newEvents],
  //   );

  //   state = AsyncData([...oldState]);

  //   return false;
  // }

  // FutureOr<bool> editEvent({
  //   required String apprenticeId,
  //   required EventDto event,
  // }) async {
  //   final apprentice = state.valueOrNull?.singleWhere(
  //         (element) => element.id == apprenticeId,
  //         orElse: () => const ApprenticeDto(),
  //       ) ??
  //       const ApprenticeDto();

  //   final oldState = state.valueOrNull ?? [];

  //   final apprenticeIndex = state.valueOrNull?.indexOf(apprentice) ?? -1;

  //   if (apprenticeIndex == -1) return false;

  //   final newState = state.valueOrNull ?? [];

  //   final eventIndex = apprentice.events.indexWhere(
  //     (element) => element.id == event.id,
  //   );

  //   if (eventIndex == -1) return false;

  //   final newEventsList = [...apprentice.events];

  //   newEventsList.removeAt(eventIndex);
  //   newEventsList.insert(eventIndex, event);

  //   newState[apprenticeIndex] = apprentice.copyWith(
  //     events: [...newEventsList],
  //   );

  //   state = AsyncData([...newState]);

  //   await Future.delayed(const Duration(milliseconds: 200));

  //   if (faker.randomGenerator.boolean()) {
  //     return true;
  //   }

  //   oldState[apprenticeIndex] = apprentice.copyWith(
  //     events: [...apprentice.events],
  //   );

  //   state = AsyncData([...oldState]);

  //   return false;
  // }

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
}
