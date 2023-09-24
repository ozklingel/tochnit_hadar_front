import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apprentices_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class ApprenticesController extends _$ApprenticesController {
  @override
  FutureOr<List<ApprenticeDto>> build() async {
    return List.generate(
      Consts.mockApprenticeGuids.length,
      (index) => ApprenticeDto(
        id: Consts.mockApprenticeGuids[index],
        avatar: faker.image.image(
          height: 75,
          width: 75,
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
        dateOfBirth: faker.date
            .dateTime(minYear: 1971, maxYear: 2004)
            .millisecondsSinceEpoch,
        maritalStatus: faker.lorem.word(),
        educationFaculty: faker.lorem.word(),
        educationalInstitution: faker.lorem.word(),
        workOccupation: faker.lorem.word(),
        workPlace: faker.lorem.word(),
        workStatus: faker.lorem.word(),
        workType: faker.lorem.word(),
        highSchoolInstitution: faker.lorem.word(),
        highSchoolRavMelamed: faker.lorem.word(),
        thInstitution: faker.lorem.word(),
        thMentor: faker.person.name(),
        thPeriod: faker.lorem.word()[0],
        thRavMelamedYearA: '${faker.person.name()} ${faker.phoneNumber.de()}',
        thRavMelamedYearB: '${faker.person.name()} ${faker.phoneNumber.us()}',
        militaryCompound:
            Consts.mockCompoundGuids[index % Consts.mockCompoundGuids.length],
        militaryDateOfDischarge:
            faker.date.dateTime(minYear: 1971).millisecondsSinceEpoch,
        militaryDateOfEnlistment:
            faker.date.dateTime(minYear: 1971).millisecondsSinceEpoch,
        militaryPositionNew: faker.lorem.word(),
        militaryPositionOld: faker.lorem.word(),
        militaryUnit: faker.lorem.word(),
        reports: List.generate(
          7,
          (index) => faker.guid.guid(),
        ),
        events: List.generate(
          7,
          (index) => EventDto(
            id: faker.guid.guid(),
            title: faker.lorem.word(),
            description: faker.lorem.sentence(),
            dateTime: faker.date.dateTime(minYear: 1971).millisecondsSinceEpoch,
          ),
        ),
        contacts: List.generate(
          3,
          (index) => ContactDto(
            id: faker.guid.guid(),
            firstName: faker.person.firstName(),
            lastName: faker.person.lastName(),
            phone: faker.phoneNumber.de(),
            email: faker.internet.email(),
            relationship: faker.lorem.word(),
          ),
        ),
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
