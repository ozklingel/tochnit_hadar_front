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
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String id,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String firstName,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String lastName,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String teudatZehut,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String phone,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String email,
    @Default('https://www.gravatar.com/avatar')
    @JsonKey(
      includeIfNull: true,
    )
    String avatar,
    @Default('')
    @JsonKey(
      includeIfNull: true,
      name: 'marriage_status',
    )
    String maritalStatus,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String highSchoolInstitution,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String highSchoolRavMelamed,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String workStatus,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String workOccupation,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String workType,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String workPlace,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String educationalInstitution,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String educationFaculty,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String institutionId,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String thPeriod,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String thMentor,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String militaryUnit,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String militaryPositionOld,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String militaryPositionNew,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String matsber,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String onlineStatus,
    @Default(0)
    @JsonKey(
      includeIfNull: true,
    )
    int militaryUpdatedDateTime,
    @Default(0)
    @JsonKey(
      includeIfNull: true,
    )
    int militaryDateOfEnlistment,
    @Default(0)
    @JsonKey(
      includeIfNull: true,
    )
    int militaryDateOfDischarge,
    @Default(0)
    @JsonKey(
      includeIfNull: true,
    )
    int dateOfBirth,
    @Default(ContactDto())
    @JsonKey(
      includeIfNull: true,
    )
    ContactDto thRavMelamedYearA,
    @Default(ContactDto())
    @JsonKey(
      includeIfNull: true,
    )
    ContactDto thRavMelamedYearB,
    @Default(AddressDto())
    @JsonKey(
      includeIfNull: true,
    )
    AddressDto address,
    @Default('')
    @JsonKey(
      includeIfNull: true,
    )
    String militaryCompoundId,
    @Default([])
    @JsonKey(
      includeIfNull: true,
    )
    List<ContactDto> contacts,
    @Default([])
    @JsonKey(
      includeIfNull: true,
    )
    List<EventDto> events,
    @Default([])
    @JsonKey(
      includeIfNull: true,
    )
    List<String> reportsIds,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

extension ApprenticeX on ApprenticeDto {
  String get fullName => '$firstName $lastName';
}
