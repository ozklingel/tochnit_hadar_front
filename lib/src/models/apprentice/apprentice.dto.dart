import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';

part 'apprentice.dto.f.dart';
part 'apprentice.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeDto with _$ApprenticeDto {
  const factory ApprenticeDto({
    @Default('') String id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String teudatZehut,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String avatar,
    @Default('') String city,
    @Default('') String street,
    @Default('') String houseNumber,
    @Default('') String apartment,
    @Default('') String region,
    @Default('') String entrance,
    @Default('') String floor,
    @Default('') String postalCode,
    @Default('') String maritalStatus,
    @Default('') String highSchoolInstitution,
    // ריש מתיבתא
    @Default('') String highSchoolRavMelamed,
    @Default('') String workStatus,
    @Default('') String workOccupation,
    @Default('') String workType,
    @Default('') String workPlace,
    @Default('') String educationalInstitution,
    @Default('') String educationFaculty,
    @Default('') String thInstitution,
    @Default('') String thPeriod,
    @Default('') String thRavMelamedYearA,
    @Default('') String thRavMelamedYearB,
    @Default('') String thMentor,
    @Default('') String militaryBase,
    @Default('') String militaryUnit,
    @Default('') String militaryPositionOld,
    @Default('') String militaryPositionNew,
    @Default(0) int militaryDateOfEnlistment,
    @Default(0) int militaryDateOfDischarge,
    @Default([]) List<ContactDto> contacts,
    @Default([]) List<EventDto> events,
    @Default([]) List<ReportDto> reports,
    // InMillisecondsSinceEpoch
    @Default(0) int dateOfBirth,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

extension ApprenticeX on ApprenticeDto {
  String get fullName => '$firstName $lastName';
  String get address => '$city, $street $houseNumber';
}

@JsonSerializable()
@Freezed(fromJson: false)
class ContactDto with _$ContactDto {
  const factory ContactDto({
    @Default('') String id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String relationship,
  }) = _ContactDto;

  // ignore: unused_element
  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);
}

extension ContactDtoX on ContactDto {
  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
@Freezed(fromJson: false)
class EventDto with _$EventDto {
  const factory EventDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int dateTime,
  }) = _EventDto;

  // ignore: unused_element
  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}
