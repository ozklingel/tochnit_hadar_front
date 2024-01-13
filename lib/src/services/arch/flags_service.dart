import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/flags/flags.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flags_service.g.dart';

@Riverpod(
  dependencies: [],
)
class FlagsService extends _$FlagsService {
  @override
  FlagsDto build() {
    return FlagsDto(
      isMock: false,
      user: UserDto(
        id: '1',
        firstName: 'אלכסוש',
        lastName: 'ינונוש',
        email: 'alexush@yanonush.com',
        role: UserRole.ahraiTohnit,
        apprentices: (_apprentices..shuffle())
            .take(faker.randomGenerator.integer(10, min: 5))
            .map((e) => e.id)
            .toList(),
      ),
      apprentices: _apprentices,
    );
  }
}

final _apprentices = List.generate(
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
    highSchoolRavMelamedName: faker.person.name(),
    highSchoolRavMelamedEmail: faker.internet.email(),
    highSchoolRavMelamedPhone: faker.phoneNumber.de(),
    institutionId: Consts.mockInstitutionsGuids[
        faker.randomGenerator.integer(Consts.mockInstitutionsGuids.length)],
    thMentor: faker.person.name(),
    thPeriod: faker.lorem.word()[0],
    thRavMelamedYearAName: faker.person.name(),
    thRavMelamedYearAEmail: faker.internet.email(),
    thRavMelamedYearAPhone: faker.phoneNumber.us(),
    thRavMelamedYearBName: faker.person.name(),
    thRavMelamedYearBEmail: faker.internet.email(),
    thRavMelamedYearBPhone: faker.phoneNumber.us(),
    contact1FirstName: faker.person.firstName(),
    contact1LastName: faker.person.lastName(),
    contact1Email: faker.internet.email(),
    contact1Phone: faker.phoneNumber.us(),
    contact1Relationship: faker.lorem.word(),
    contact2FirstName: faker.person.firstName(),
    contact2LastName: faker.person.lastName(),
    contact2Email: faker.internet.email(),
    contact2Phone: faker.phoneNumber.us(),
    contact2Relationship: faker.lorem.word(),
    contact3FirstName: faker.person.firstName(),
    contact3LastName: faker.person.lastName(),
    contact3Email: faker.internet.email(),
    contact3Phone: faker.phoneNumber.us(),
    contact3Relationship: faker.lorem.word(),
    militaryCompoundId: Consts.mockCompoundGuids[
        faker.randomGenerator.integer(Consts.mockCompoundGuids.length)],
    militaryDateOfDischarge:
        faker.date.dateTime(minYear: 1971).toIso8601String(),
    militaryDateOfEnlistment:
        faker.date.dateTime(minYear: 1971).toIso8601String(),
    militaryPositionNew: faker.lorem.word(),
    militaryPositionOld: faker.lorem.word(),
    militaryUnit: faker.lorem.word(),
    reportsIds: [],
    events: List.generate(
      Consts.mockEventsGuids.length,
      (index) => EventDto(
        id: Consts.mockEventsGuids[index],
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
        datetime: faker.date.dateTime().toIso8601String(),
      ),
    ),
  ),
);
