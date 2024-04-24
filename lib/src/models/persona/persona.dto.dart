import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'persona.dto.f.dart';
part 'persona.dto.g.dart';

enum StatusColor {
  grey(100),
  green(200),
  orange(300),
  red(400),
  invis(999);

  const StatusColor(this.value);
  final int value;

  Color toColor() {
    return this == StatusColor.green
        ? AppColors.green2
        : this == StatusColor.red
            ? AppColors.red2
            : this == StatusColor.orange
                ? AppColors.yellow1
                : Colors.transparent;
  }
}

enum Relationship {
  mother,
  father,
  sister,
  brother,
  wife,
  husband,
  other,
}

typedef Phone = String;

@JsonSerializable()
@Freezed(fromJson: false)
class PersonaDto with _$PersonaDto {
  const factory PersonaDto({
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
    Phone contact1Phone,
    @Default(Relationship.other)
    @JsonKey(
      name: 'contact1_relation',
      fromJson: _extractRelationship,
    )
    Relationship contact1Relationship,
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
    Phone contact2Phone,
    @Default(Relationship.other)
    @JsonKey(
      name: 'contact2_relation',
      fromJson: _extractRelationship,
    )
    Relationship contact2Relationship,
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
    Phone contact3Phone,
    @Default(Relationship.other)
    @JsonKey(
      name: 'contact3_relation',
      fromJson: _extractRelationship,
    )
    Relationship contact3Relationship,
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
      name: 'events',
      fromJson: _parseEvents,
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
    Phone highSchoolRavMelamedPhone,
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
    Phone phone,
    @Default([])
    @JsonKey(
      name: 'reports',
      fromJson: _extractReports,
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
    Phone thRavMelamedYearAPhone,
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
    Phone thRavMelamedYearBPhone,
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
    @Default(StatusColor.grey)
    @JsonKey(
      name: 'call_status',
      fromJson: _parseStatus,
    )
    StatusColor callStatus,
    @Default(StatusColor.grey)
    @JsonKey(
      name: 'personalMeet_status',
      fromJson: _parseStatus,
    )
    StatusColor personalMeetStatus,
    @Default(StatusColor.grey)
    @JsonKey(
      name: 'Horim_status',
      fromJson: _parseStatus,
    )
    StatusColor parentsStatus,
    @Default(0)
    @JsonKey(
      name: 'activity_score',
      fromJson: _extractActivityScore,
    )
    int activityScore,
    @Default(false)
    @JsonKey(
      name: 'paying',
      fromJson: _extractPaying,
    )
    bool isPaying,
  }) = _Persona;

  factory PersonaDto.fromJson(Map<String, dynamic> json) =>
      _$PersonaDtoFromJson(json);
}

bool _extractPaying(String? data) {
  if (data == 'משלם') {
    return true;
  }

  return false;
}

int _extractActivityScore(dynamic val) {
  if (val is int) {
    return val;
  }

  final result = int.tryParse(val);

  if (result == null) {
    Logger().w('extractActivityScore');
    Sentry.captureException(
      Exception('failed to extract extractActivityScore'),
    );

    return 0;
  }

  return result;
}

StatusColor _parseStatus(dynamic val) {
  if (val == null) {
    Logger().w('status color null');
    Sentry.captureException(
      Exception('failed to extract status color'),
    );

    return StatusColor.grey;
  }

  switch (val) {
    case 'red':
      return StatusColor.red;
    case 'green':
      return StatusColor.green;
    case 'orange':
      return StatusColor.orange;
    default:
      Logger().w('bad status color');
      Sentry.captureException(
        Exception('failed to extract status color'),
      );

      return StatusColor.grey;
  }
}

List<String> _extractReports(dynamic val) {
  // TODO(oz): fix this
  if (val is List<dynamic>) {
    if (val is List<String>) {
      return val;
    } else {
      const errMsg = 'MISSING REPORTS PARSE IMPLEMENTATION LIST';
      // not suposed to be here but found this during dev so putting it here
      Sentry.captureMessage(errMsg);
      Logger().w('$errMsg list', error: val);
    }
  } else if (val is String) {
    const errMsg = 'MISSING REPORTS PARSE IMPLEMENTATION STRING';
    // not suposed to be here but found this during dev so putting it here
    Sentry.captureMessage(errMsg);
    Logger().w(errMsg, error: val);

    return [];
  }

  return [];
}

List<EventDto> _parseEvents(dynamic val) {
  const errMsg = 'MISSING EVENTS PARSE IMPLEMENTATION';

  if (val is List<dynamic>) {
    Logger().w(errMsg);

    return [];
  } else if (val is String) {
    // not suposed to be here but found this during dev so putting it here
    Sentry.captureMessage(errMsg);
    Logger().w(errMsg);

    return [];
  }

  return [];
}

Relationship _extractRelationship(String? val) {
  switch (val) {
    case 'אבא':
      return Relationship.father;
    case 'אמא':
      return Relationship.mother;
    case 'אח':
      return Relationship.brother;
    case 'אחות':
      return Relationship.sister;
    case 'בעל':
      return Relationship.husband;
    case 'אישה':
      return Relationship.wife;
    default:
      return Relationship.other;
  }
}

extension ApprenticeX on PersonaDto {
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

extension PhoneX on Phone {
  String get format => '0${substring(0, 2)}-${substring(2)}';
}
