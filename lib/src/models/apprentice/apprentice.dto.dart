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
    @Default('[N/A]') String id,
    @Default('[N/A]') String firstName,
    @Default('[N/A]') String lastName,
    @Default('[N/A]') String teudatZehut,
    @Default('[N/A]') String phone,
    @Default('[N/A]') String email,
    @Default('https://www.gravatar.com/avatar') String avatar,
    @Default('[N/A]') @JsonKey(name: 'marriage_status') String maritalStatus,
    @Default('[N/A]') String highSchoolInstitution,
    @Default('[N/A]') String highSchoolRavMelamed,
    @Default('[N/A]') String workStatus,
    @Default('[N/A]') String workOccupation,
    @Default('[N/A]') String workType,
    @Default('[N/A]') String workPlace,
    @Default('[N/A]') String educationalInstitution,
    @Default('[N/A]') String educationFaculty,
    @Default('[N/A]') String thInstitution,
    @Default('[N/A]') String thPeriod,
    @Default('[N/A]') String thMentor,
    @Default('[N/A]') String militaryUnit,
    @Default('[N/A]') String militaryPositionOld,
    @Default('[N/A]') String militaryPositionNew,
    @Default('[N/A]') String matsber,
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
