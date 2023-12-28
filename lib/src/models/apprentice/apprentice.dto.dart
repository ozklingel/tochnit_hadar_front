import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/contact/contact.dto.dart';

part 'apprentice.dto.f.dart';
part 'apprentice.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeDto with _$ApprenticeDto {
  const factory ApprenticeDto({
    @Default(AddressDto()) AddressDto address,
    @Default('') @JsonKey(name: 'army_role') String militaryUnit,
    @Default('') @JsonKey(name: 'birthday') String dateOfBirth,
    @Default('') @JsonKey(name: 'contact1_email') String contact1Email,
    @Default('') @JsonKey(name: 'contact1_first_name') String contact1FirstName,
    @Default('') @JsonKey(name: 'contact1_last_name') String contact1LastName,
    @Default('') @JsonKey(name: 'contact1_phone') String contact1Phone,
    @Default('')
    @JsonKey(name: 'contact1_relation')
    String contact1Relationship,
    @Default('') @JsonKey(name: 'contact2_email') String contact2Email,
    @Default('') @JsonKey(name: 'contact2_first_name') String contact2FirstName,
    @Default('') @JsonKey(name: 'contact2_last_name') String contact2LastName,
    @Default('') @JsonKey(name: 'contact2_phone') String contact2Phone,
    @Default('')
    @JsonKey(name: 'contact2_relation')
    String contact2Relationship,
    @Default('') @JsonKey(name: 'contact3_email') String contact3Email,
    @Default('') @JsonKey(name: 'contact3_first_name') String contact3FirstName,
    @Default('') @JsonKey(name: 'contact3_last_name') String contact3LastName,
    @Default('') @JsonKey(name: 'contact3_phone') String contact3Phone,
    @Default('')
    @JsonKey(name: 'contact3_relation')
    String contact3Relationship,
    @Default('') String educationFaculty,
    @Default('') String educationalInstitution,
    @Default('') String email,
    @Default([]) @JsonKey(name: 'events') List<String> eventIds,
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
    @Default('') String avatar,
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
  List<String> get tags => [
        highSchoolInstitution,
        thPeriod,
        militaryPositionNew,
        militaryUnit,
        maritalStatus,
      ];
}
