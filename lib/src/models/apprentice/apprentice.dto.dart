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
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'army_role',
    )
    String militaryUnit,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'birthday',
    )
    String dateOfBirth,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact1_email',
    )
    String contact1Email,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact1_first_name',
    )
    String contact1FirstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact1_last_name',
    )
    String contact1LastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact1_phone',
    )
    String contact1Phone,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact1_relation',
    )
    String contact1Relationship,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact2_email',
    )
    String contact2Email,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact2_first_name',
    )
    String contact2FirstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact2_last_name',
    )
    String contact2LastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact2_phone',
    )
    String contact2Phone,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact2_relation',
    )
    String contact2Relationship,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact3_email',
    )
    String contact3Email,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact3_first_name',
    )
    String contact3FirstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact3_last_name',
    )
    String contact3LastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact3_phone',
    )
    String contact3Phone,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact3_relation',
    )
    String contact3Relationship,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String educationFaculty,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String educationalInstitution,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String email,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'events',
    )
    List<EventDto> events,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'highSchoolRavMelamed_email',
    )
    String highSchoolRavMelamedEmail,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'highSchoolRavMelamed_name',
    )
    String highSchoolRavMelamedName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'highSchoolRavMelamed_phone',
    )
    String highSchoolRavMelamedPhone,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'institution_id',
    )
    String institutionId,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'last_name',
    )
    String lastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'marriage_status',
    )
    String maritalStatus,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryPositionOld,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryUpdatedDateTime,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'name',
    )
    String firstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String phone,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'reports',
    )
    List<String> reportsIds,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearA_email',
    )
    String thRavMelamedYearAEmail,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearA_name',
    )
    String thRavMelamedYearAName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearA_phone',
    )
    String thRavMelamedYearAPhone,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearB_email',
    )
    String thRavMelamedYearBEmail,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearB_name',
    )
    String thRavMelamedYearBName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'thRavMelamedYearB_phone',
    )
    String thRavMelamedYearBPhone,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String workOccupation,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String workPlace,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String workStatus,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String workType,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String teudatZehut,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String avatar,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String highSchoolInstitution,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String thPeriod,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String thMentor,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryPositionNew,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String matsber,
    @Default(OnlineStatus.offline)
    @JsonKey(fromJson: _parseOnlineStatus)
    OnlineStatus onlineStatus,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryDateOfEnlistment,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryDateOfDischarge,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String militaryCompoundId,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}

OnlineStatus _parseOnlineStatus(dynamic onlineStatus) {
  if (onlineStatus == null) {
    Logger().w('online status null');
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

  Logger().w('online status index too high');
  Sentry.captureException(
    Exception('failed to extract online status index too high'),
  );

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
