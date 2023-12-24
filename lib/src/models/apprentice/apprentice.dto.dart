import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/contact/contact.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';

part 'apprentice.dto.f.dart';
part 'apprentice.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeDto with _$ApprenticeDto {
  const factory ApprenticeDto({
    @Default(AddressDto()) AddressDto address,
    @Default('') @JsonKey(name: 'army_role') String militaryUnit,
    @Default('') @JsonKey(name: 'birthday') String dateOfBirth,
    @Default([]) List<ContactDto> contacts,
    @Default('') String educationFaculty,
    @Default('') String educationInstitution,
    @Default('') String email,
    @Default([]) List<EventDto> events,
    @Default(ContactDto()) ContactDto highSchoolRavMelamed,
    @Default('') String id,
    @Default('') @JsonKey(name: 'institution_id') String institutionId,
    @Default('') @JsonKey(name: 'last_name') String lastName,
    @Default('') @JsonKey(name: 'marriage_status') String maritalStatus,
    @Default('') String militaryPositionOld,
    @Default('') String militaryUpdatedDateTime,
    @Default('') @JsonKey(name: 'name') String firstName,
    @Default('') String phone,
    @Default([]) @JsonKey(name: 'reports') List<String> reportsIds,
    @Default(ContactDto()) ContactDto thRavMelamedYearA,
    @Default(ContactDto()) ContactDto thRavMelamedYearB,
    @Default('') String workOccupation,
    @Default('') String workPlace,
    @Default('') String workStatus,
    @Default('') String workType,
    @Default('') String teudatZehut,
    @Default('https://www.gravatar.com/avatar') String avatar,
    @Default('') @Default('') String highSchoolInstitution,
    @Default('') String thPeriod,
    @Default('') String thMentor,
    @Default('') String militaryPositionNew,
    @Default('') String matsber,
    @Default('') String onlineStatus,
    @Default('') String militaryDateOfEnlistment,
    @Default('') String militaryDateOfDischarge,
    @Default('') String militaryCompoundId,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

extension ApprenticeX on ApprenticeDto {
  String get fullName => '$firstName $lastName';
}
