import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/apprentice/get_maps_apprentices.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'personas_controller.g.dart';

@Riverpod(
  dependencies: [
    GetMapsApprentices,
    GetPersonas,
    DioService,
    GetFilteredUsers,
    GetMapsApprentices,
    StorageService,
  ],
)
class PersonasController extends _$PersonasController {
  var _filters = const FilterDto();

  @override
  FutureOr<List<PersonaDto>> build() async {
    final mapApprentices = await ref.watch(getMapsApprenticesProvider.future);
    final personas2 = await ref.watch(getPersonasProvider.future);

    ref.keepAlive();

    final uniquePersonas = personas2
        .whereNot(
          (element) => mapApprentices.map((e) => e.id).contains(element.id),
        )
        .toList();

    return mapApprentices + uniquePersonas;
  }

  FutureOr<bool> deletePersona(String personaId) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
            Consts.deletePersona,
            data: jsonEncode({
              'userId': personaId,
            }),
          );

      if (result.data['result'] == 'success') {
        // ref.read(goRouterServiceProvider).go('/home');
        ref.invalidate(getMapsApprenticesProvider);
        ref.invalidate(getPersonasProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to delete persona', error: e);
      Sentry.captureException(e, stackTrace: StackTrace.current);
      Toaster.error(e);
    }

    return false;
  }

  FutureOr<bool> addEvent({
    required EventDto event,
    required String apprenticeId,
  }) async {
    try {
      final req = await ref.read(dioServiceProvider).post(
        Consts.addNotification,
        data: {
          'userId': ref.read(storageServiceProvider.notifier).getUserPhone(),
          'apprenticeid': apprenticeId,
          'event': event.eventType,
          'details': event.description,
          'frequency': 'frequency',
          'date': event.datetime,
          // this is due to backend bug
          'subject': apprenticeId,
        },
      );

      if (req.data['result'] == 'success') {
        ref.invalidate(getPersonasProvider);
        ref.invalidate(getMapsApprenticesProvider);
        return true;
      }
    } catch (e) {
      Logger().e('failed to add event', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  FutureOr<bool> deleteEvent({
    required String eventId,
  }) async {
    try {
      final req = await ref.read(dioServiceProvider).post(
        Consts.deleteNotification,
        data: {
          'NotificationId': eventId,
        },
      );

      if (req.data['result'] == 'success') {
        ref.invalidate(getPersonasProvider);
        ref.invalidate(getMapsApprenticesProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to delete event', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  FutureOr<bool> editEvent({
    required String apprenticeId,
    required EventDto event,
  }) async {
    try {
      final req = await ref.read(dioServiceProvider).put(
        Consts.updateNotification,
        queryParameters: {
          'NotificationId': event.id,
        },
        data: {
          // 'userId': ref.read(storageServiceProvider.notifier).getUserPhone(),
          'apprenticeId': apprenticeId,
          'date': event.datetime,
          'details': event.description,
          'event': event.eventType,
          'frequency': 'frequency',
          "numOfLinesDisplay": 2,
          // this is due to backend bug
          'subject': apprenticeId,
          // "title": event.title,
        },
      );

      if (req.data['result'] == 'success') {
        ref.invalidate(getPersonasProvider);
        ref.invalidate(getMapsApprenticesProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to edit event', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

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
        data: {
          'avatar': persona.avatar,
          // military
          'militaryCompoundId': persona.militaryCompoundId,
          'militaryUnit': persona.militaryServiceType,
          'militaryPositionNew': persona.militaryPositionNew,
          'militaryPositionOld': persona.militaryPositionOld,
          'militaryDateOfEnlistment': persona.militaryDateOfEnlistment,
          'militaryDateOfDischarge': persona.militaryDateOfDischarge,
          // personal general
          'teudatZehut': persona.teudatZehut,
          'email': persona.email,
          // ! TODO(OZ): this field won't update
          // 'address': persona.address,
          'marriage_status': persona.maritalStatus,
          'phone': persona.phone,
          // personal dates
          'birthday': persona.dateOfBirth,
          // personal relationships
          'contact1_relation': persona.contact1Relationship.name,
          'contact1_phone': persona.contact1Phone,
          'contact1_email': persona.contact1Email,
          'contact1_first_name': persona.contact1FirstName,
          'contact1_last_name': persona.contact1LastName,
          'contact2_relation': persona.contact2Relationship.name,
          'contact2_phone': persona.contact2Phone,
          'contact2_email': persona.contact2Email,
          'contact2_first_name': persona.contact2FirstName,
          'contact2_last_name': persona.contact2LastName,
          'contact3_relation': persona.contact3Relationship.name,
          'contact3_phone': persona.contact3Phone,
          'contact3_email': persona.contact3Email,
          'contact3_first_name': persona.contact3FirstName,
          'contact3_last_name': persona.contact3LastName,
          // personal high school
          'highSchoolInstitution': persona.highSchoolInstitution,
          'highSchoolRavMelamed_name': persona.highSchoolRavMelamedName,
          'highSchoolRavMelamed_phone': persona.highSchoolRavMelamedPhone,
          'highSchoolRavMelamed_email': persona.highSchoolRavMelamedEmail,
          // personal work
          'workStatus': persona.workStatus,
          'workOccupation': persona.workOccupation,
          'workPlace': persona.workPlace,
          'workType': persona.workType,
          // tohnit hadar
          'educationalInstitution': persona.educationalInstitution,
          'thPeriod': persona.thPeriod,
          'thRavMelamedYearA_name': persona.thRavMelamedYearAName,
          'thRavMelamedYearA_phone': persona.thRavMelamedYearAPhone,
          'thRavMelamedYearB_name': persona.thRavMelamedYearBName,
          'thRavMelamedYearB_phone': persona.thRavMelamedYearBPhone,
          'paying': persona.payingString,
          'matsber': persona.matsbarStatus,
        },
      );

      Logger().d(result);

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

  FutureOr<List<String>?> filterUsers(FilterDto filter) async {
    _filters = filter;

    if (_filters.isEmpty) {
      ref.invalidateSelf();

      return null;
    }

    try {
      final request = await ref.read(getFilteredUsersProvider(_filters).future);

      state = AsyncData(
        state.requireValue
            .where((element) => request.contains(element.id))
            .toList(),
      );

      return request;
    } catch (e) {
      Logger().e('failed to filter users', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return null;
  }
}
