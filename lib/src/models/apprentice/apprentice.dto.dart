import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';

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
    @Default('https://www.gravatar.com/avatar') String avatar,
    @Default('') @JsonKey(name: 'marriage_status') String maritalStatus,
    @Default('') String highSchoolInstitution,
    @Default('') String highSchoolRavMelamed,
    @Default('') String workStatus,
    @Default('') String workOccupation,
    @Default('') String workType,
    @Default('') String workPlace,
    @Default('') String educationalInstitution,
    @Default('') String educationFaculty,
    @Default('') String thInstitution,
    @Default('') String thPeriod,
    @Default('') String thMentor,
    @Default('') String militaryUnit,
    @Default('') String militaryPositionOld,
    @Default('') String militaryPositionNew,
    @Default('') String matsber,
    @Default('') String onlineStatus,
    @Default(0) int militaryUpdatedDateTime,
    @Default(0) int militaryDateOfEnlistment,
    @Default(0) int militaryDateOfDischarge,
    @Default(0) int dateOfBirth,
    @Default(ContactDto()) ContactDto thRavMelamedYearA,
    @Default(ContactDto()) ContactDto thRavMelamedYearB,
    @Default(AddressDto()) AddressDto address,
    @Default(CompoundDto()) CompoundDto militaryCompound,
    @Default([]) List<ContactDto> contacts,
    @Default([]) List<EventDto> events,
    @Default([]) List<String> reports,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

extension ApprenticeX on ApprenticeDto {
  String get fullName => '$firstName $lastName';
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
