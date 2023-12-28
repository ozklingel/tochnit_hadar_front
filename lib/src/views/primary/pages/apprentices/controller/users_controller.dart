import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/contact/contact.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_controller.g.dart';

@Riverpod(
  dependencies: [
    dio,
  ],
)
class UsersController extends _$UsersController {
  @override
  FutureOr<List<ApprenticeDto>> build() async {
    // ignore: unused_local_variable
    final request =
        ref.watch(dioProvider).get('userProfile_form/myApprentices');

    await Future.delayed(const Duration(milliseconds: 400));

    return List.generate(
      Consts.mockApprenticeGuids.length,
      (index) => ApprenticeDto(
        id: Consts.mockApprenticeGuids[index],
        avatar: faker.image.image(
          height: 75,
          width: 75,
          random: true,
        ),
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        phone: faker.randomGenerator.boolean()
            ? ''
            : faker.randomGenerator.boolean()
                ? faker.phoneNumber.de()
                : faker.phoneNumber.us(),
        email: faker.randomGenerator.boolean() ? '' : faker.internet.email(),
        teudatZehut: faker.randomGenerator.numberOfLength(9),
        address: AddressDto(
          city: faker.address.city(),
          apartment: faker.randomGenerator.integer(99999, min: 1).toString(),
          street: faker.address.streetName(),
          houseNumber: faker.randomGenerator.integer(999, min: 1).toString(),
          postalCode: faker.address.zipCode(),
          floor: faker.randomGenerator.integer(99, min: 1).toString(),
          entrance: faker.lorem.word()[0],
          region: faker.address.state(),
        ),
        dateOfBirth:
            faker.date.dateTime(minYear: 1971, maxYear: 2004).toIso8601String(),
        maritalStatus: faker.lorem.word(),
        educationFaculty: faker.lorem.word(),
        educationalInstitution: faker.lorem.word(),
        workOccupation: faker.lorem.word(),
        workPlace: faker.lorem.word(),
        workStatus: faker.lorem.word(),
        workType: faker.lorem.word(),
        highSchoolInstitution: faker.lorem.word(),
        highSchoolRavMelamed: const ContactDto(),
        institutionId: faker.lorem.word(),
        matsber: faker.lorem.word(),
        militaryUpdatedDateTime:
            faker.date.dateTime(minYear: 1971, maxYear: 2004).toIso8601String(),
        thMentor: faker.person.name(),
        thPeriod: faker.lorem.word()[0],
        thRavMelamedYearA: ContactDto(
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          phone: faker.phoneNumber.us(),
        ),
        thRavMelamedYearB: ContactDto(
          firstName: faker.person.firstName(),
          lastName: faker.person.lastName(),
          phone: faker.phoneNumber.de(),
        ),
        militaryCompoundId: Consts.mockCompoundGuids[
            faker.randomGenerator.integer(Consts.mockCompoundGuids.length)],
        militaryDateOfDischarge:
            faker.date.dateTime(minYear: 1971).toIso8601String(),
        militaryDateOfEnlistment:
            faker.date.dateTime(minYear: 1971).toIso8601String(),
        militaryPositionNew: faker.lorem.word(),
        militaryPositionOld: faker.lorem.word(),
        militaryUnit: faker.lorem.word(),
        reportsIds: List.generate(
          7,
          (index) => faker.guid.guid(),
        ),
        eventIds: List.generate(
          Consts.mockEventsGuids.length,
          (index) => faker.guid.guid(),
        ),
        contact1Email: faker.internet.email(),
        contact1FirstName: faker.person.firstName(),
        contact1LastName: faker.person.lastName(),
        contact1Phone: faker.phoneNumber.de(),
        contact2Email: faker.internet.email(),
        contact2FirstName: faker.person.firstName(),
        contact2LastName: faker.person.lastName(),
        contact2Phone: faker.phoneNumber.us(),
        contact3Email: faker.internet.email(),
        contact3FirstName: faker.person.firstName(),
        contact3LastName: faker.person.lastName(),
        contact3Phone: faker.phoneNumber.de(),
        onlineStatus: faker.randomGenerator.boolean() ? 'online' : 'offline',
      ),
    );
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
      eventIds: [...apprentice.eventIds, event.id],
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
        apprentice.eventIds.firstWhere((element) => element == eventId);

    final newEvents = [...apprentice.eventIds];

    final oldEventIndex = newEvents.indexOf(event);

    newEvents.removeAt(oldEventIndex);

    newState[apprenticeIndex] = apprentice.copyWith(
      eventIds: [...newEvents],
    );

    state = AsyncData([...newState]);

    await Future.delayed(const Duration(milliseconds: 200));

    if (faker.randomGenerator.boolean()) {
      return true;
    }

    // TODO(noga-dev): if old event's date changes should it be sorted?

    newEvents.insert(oldEventIndex, event);

    oldState[apprenticeIndex] = apprentice.copyWith(
      eventIds: [...newEvents],
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

    final eventIndex = apprentice.eventIds.indexWhere(
      (element) => element == event.id,
    );

    if (eventIndex == -1) return false;

    final newEventsList = [...apprentice.eventIds];

    newEventsList.removeAt(eventIndex);
    newEventsList.insert(eventIndex, event.id);

    newState[apprenticeIndex] = apprentice.copyWith(
      eventIds: [...newEventsList],
    );

    state = AsyncData([...newState]);

    await Future.delayed(const Duration(milliseconds: 200));

    if (faker.randomGenerator.boolean()) {
      return true;
    }

    oldState[apprenticeIndex] = apprentice.copyWith(
      eventIds: [...apprentice.eventIds],
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
