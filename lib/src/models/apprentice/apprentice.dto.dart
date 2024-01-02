import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'apprentice.dto.f.dart';
part 'apprentice.dto.g.dart';

enum OnlineStatus {
  online(100),
  offline(200),
  other(300);

  const OnlineStatus(this.value);
  final int value;
}

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
    @Default([]) @JsonKey(name: 'events') List<EventDto> events,
    @Default('')
    @JsonKey(name: 'highSchoolRavMelamed_email')
    String highSchoolRavMelamedEmail,
    @Default('')
    @JsonKey(name: 'highSchoolRavMelamed_name')
    String highSchoolRavMelamedName,
    @Default('')
    @JsonKey(name: 'highSchoolRavMelamed_phone')
    String highSchoolRavMelamedPhone,
    @Default('') String id,
    @Default('') @JsonKey(name: 'institution_id') String institutionId,
    @Default('') @JsonKey(name: 'last_name') String lastName,
    @Default('') @JsonKey(name: 'marriage_status') String maritalStatus,
    @Default('') String militaryPositionOld,
    @Default('') String militaryUpdatedDateTime,
    @Default('') @JsonKey(name: 'name') String firstName,
    @Default('') String phone,
    @Default([]) @JsonKey(name: 'reports') List<String> reportsIds,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearA_email')
    String thRavMelamedYearAEmail,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearA_name')
    String thRavMelamedYearAName,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearA_phone')
    String thRavMelamedYearAPhone,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearB_email')
    String thRavMelamedYearBEmail,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearB_name')
    String thRavMelamedYearBName,
    @Default('')
    @JsonKey(name: 'thRavMelamedYearB_phone')
    String thRavMelamedYearBPhone,
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
    @Default(OnlineStatus.offline)
    @JsonKey(fromJson: _parseOnlineStatus)
    OnlineStatus onlineStatus,
    @Default('') String militaryDateOfEnlistment,
    @Default('') String militaryDateOfDischarge,
    @Default('') String militaryCompoundId,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

OnlineStatus _parseOnlineStatus(dynamic onlineStatus) {
  if (onlineStatus == null) {
    Logger().w('empty user role');
    Sentry.captureException(
      Exception('failed to extract online status from string'),
    );
    return OnlineStatus.other;
  }

  final onlineStatusIndex =
      onlineStatus is num ? onlineStatus : int.tryParse(onlineStatus);

  if (onlineStatusIndex == null) {
    Logger().w('bad online status index');
    Sentry.captureException(
      Exception('failed to extract online status from index'),
    );
    return OnlineStatus.other;
  }

  if (onlineStatusIndex == OnlineStatus.offline.value) {
    return OnlineStatus.offline;
  } else if (onlineStatusIndex == OnlineStatus.online.value) {
    return OnlineStatus.online;
  }

  return OnlineStatus.other;
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
  bool get isEmpty => id.isEmpty;
}
