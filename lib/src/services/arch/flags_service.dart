import 'dart:math';

import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/marital_status.dart';
import 'package:hadar_program/src/core/enums/relationship.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/flags/flags.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
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
      user: _userDto,
      apprentices: _apprentices,
      messages: _messages,
      notifications: _notifications,
      tasks: _tasks,
      reports: _reports,
      institutions: _institutions,
    );
  }
}

final _notifications = [
  {
    faker.person.firstName(): faker.person.lastName(),
    faker.person.firstName(): faker.person.lastName(),
    faker.person.firstName(): faker.person.lastName(),
  },
];

final _userDto = AuthDto(
  id: '1',
  firstName: 'אלכסוש',
  lastName: 'ינונוש',
  email: 'alexush@yanonush.com',
  role: UserRole.ahraiTohnit,
  apprentices: ([..._apprentices]..shuffle())
      .take(faker.randomGenerator.integer(10, min: 5))
      .map((e) => e.id)
      .toList(),
);

final _institutions = List.generate(
  Consts.mockInstitutionsGuids.length,
  (index) => InstitutionDto(
    id: Consts.mockInstitutionsGuids[index],
    name: faker.company.name(),
    rakazId: faker.person.name(),
    rakazPhoneNumber: faker.phoneNumber.de(),
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
    adminPhoneNumber: faker.phoneNumber.de(),
    roshMehinaName: faker.person.name(),
    roshMehinaPhoneNumber: faker.phoneNumber.us(),
    adminName: faker.person.name(),
    apprentices: Consts.mockApprenticeGuids
        .take(
          faker.randomGenerator.integer(Consts.mockApprenticeGuids.length),
        )
        .toList(),
    melavim: Consts.mockApprenticeGuids
        .take(
          faker.randomGenerator.integer(Consts.mockApprenticeGuids.length),
        )
        .toList(),
    score: faker.randomGenerator.integer(100).toDouble(),
  ),
);

final _reports = List.generate(
  44,
  (index) {
    return ReportDto(
      id: faker.guid.guid(),
      description: faker.lorem.sentence(),
      recipients: _apprentices.map((e) => e.id).toList(),
      event: Event.values[Random().nextInt(6)],
      attachments: List.generate(
        11,
        (index) => faker.image.image(height: 100, width: 100),
      ),
      dateTime: faker.date
          .dateTime(minYear: 1971, maxYear: DateTime.now().year)
          .toIso8601String(),
    );
  },
);

final _messages = List.generate(
  31,
  (index) {
    return MessageDto(
      id: faker.guid.guid(),
      from: _apprentices.isEmpty
          ? const PersonaDto().phone
          : _apprentices[Random().nextInt(_apprentices.length)].phone,
      title: faker.lorem.sentence(),
      content: faker.lorem.sentence(),
      icon: faker.food.dish(),
      allreadyRead: faker.randomGenerator.boolean(),
      dateTime: faker.randomGenerator.boolean()
          ? faker.date
              .dateTime(
                minYear: 1971,
                maxYear: DateTime.now().year,
              )
              .toIso8601String()
          : faker.date
              .dateTime(
                minYear: DateTime.now().year,
                maxYear: DateTime.now().year + 1,
              )
              .toIso8601String(),
      attachments: List.generate(
        Random().nextInt(2),
        (index) => faker.image.image(height: 100, width: 100),
      ),
    );
  },
);

final _tasks = List.generate(
  Consts.mockTasksGuids.length,
  (index) {
    final newApprentices = [..._apprentices];
    newApprentices.shuffle();

    return TaskDto(
      id: Consts.mockTasksGuids[index],
      status: TaskStatus
          .values[faker.randomGenerator.integer(TaskStatus.values.length)],
      details: faker.lorem.sentence(),
      subject: newApprentices
          .take(faker.randomGenerator.integer(5))
          .map((e) => e.id)
          .toList(),
      frequencyMeta: TaskFrequencyMeta.values[
          faker.randomGenerator.integer(TaskFrequencyMeta.values.length)],
      frequencyEnd: TaskFrequencyEnd.values[
          faker.randomGenerator.integer(TaskFrequencyEnd.values.length)],
      event: Event.values[faker.randomGenerator.integer(Event.values.length)],
      dateTime: faker.date
          .dateTime(
            minYear: 1972,
            maxYear: DateTime.now().year,
          )
          .toIso8601String(),
    );
  },
);

final _apprentices = List.generate(
  Consts.mockApprenticeGuids.length,
  (index) => PersonaDto(
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
    maritalStatus: MaritalStatus
        .values[faker.randomGenerator.integer(MaritalStatus.values.length)],
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
    contact1Relationship: Relationship
        .values[faker.randomGenerator.integer(Relationship.values.length)],
    contact2FirstName: faker.person.firstName(),
    contact2LastName: faker.person.lastName(),
    contact2Email: faker.internet.email(),
    contact2Phone: faker.phoneNumber.us(),
    contact2Relationship: Relationship
        .values[faker.randomGenerator.integer(Relationship.values.length)],
    contact3FirstName: faker.person.firstName(),
    contact3LastName: faker.person.lastName(),
    contact3Email: faker.internet.email(),
    contact3Phone: faker.phoneNumber.us(),
    contact3Relationship: Relationship
        .values[faker.randomGenerator.integer(Relationship.values.length)],
    militaryCompoundId: Consts.mockCompoundGuids[
        faker.randomGenerator.integer(Consts.mockCompoundGuids.length)],
    militaryDateOfDischarge:
        faker.date.dateTime(minYear: 1971).toIso8601String(),
    militaryDateOfEnlistment:
        faker.date.dateTime(minYear: 1971).toIso8601String(),
    militaryPositionNew: faker.lorem.word(),
    militaryPositionOld: faker.lorem.word(),
    militaryServiceType: faker.lorem.word(),
    reportsIds: [],
    events: List.generate(
      Consts.mockEventsGuids.length,
      (index) => EventDto(
        id: Consts.mockEventsGuids[index],
        eventType: faker.lorem.word(),
        description: faker.lorem.sentence(),
        datetime: faker.date.dateTime().toIso8601String(),
      ),
    ),
  ),
);
