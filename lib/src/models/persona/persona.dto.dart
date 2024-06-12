import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/utils/convert/extract_from_json.dart';
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
  other;

  String get name {
    switch (this) {
      case mother:
        return 'אמא';
      case Relationship.father:
        return 'אבא';
      case Relationship.sister:
        return 'אחות';
      case Relationship.brother:
        return 'אח';
      case Relationship.wife:
        return 'אישה';
      case Relationship.husband:
        return 'בעל';
      case Relationship.other:
        return 'אחר';
    }
  }
}

enum MilitaryServiceType {
  commando,
  battalion,
  rear;

  String get hebrewName => switch (this) {
        MilitaryServiceType.commando => 'סיירת',
        MilitaryServiceType.battalion => 'גדוד',
        MilitaryServiceType.rear => 'עורפי',
      };
}

typedef Phone = String;

@JsonSerializable()
@Freezed(fromJson: false)
class PersonaDto with _$PersonaDto {
  const PersonaDto._();
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
    @Default([])
    @JsonKey(
      name: 'role',
      fromJson: _extractRole,
    )
    List<UserRole> roles,
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
      fromJson: extractAvatarFromJson,
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
      name: 'matsber',
      defaultValue: '',
    )
    String spiritualStatus,
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

  String get payingString => isPaying ? 'משלם' : 'לא משלם';

  String? _phoneByRelationship(Relationship relationship) {
    if (relationship == contact1Relationship) return contact1Phone;
    if (relationship == contact2Relationship) return contact2Phone;
    if (relationship == contact3Relationship) return contact3Phone;
    return null;
  }

  String? get motherPhone => _phoneByRelationship(Relationship.mother);
  String? get fatherPhone => _phoneByRelationship(Relationship.father);

  factory PersonaDto.fromJson(Map<String, dynamic> json) =>
      _$PersonaDtoFromJson(json);
}

List<UserRole> _extractRole(List<dynamic>? data) {
  if (data == null) {
    return [];
  }

  if (data.isEmpty) {
    return [];
  }

  final result =
      UserRole.values.where((element) => data.contains(element.index)).toList();

  return result;
}

bool _extractPaying(String? data) => data == 'משלם';

int _extractActivityScore(dynamic val) {
  if (val is int) {
    return val;
  }

  final result = int.tryParse(val);

  if (result == null) {
    Logger().w('failed to extract extractActivityScore: null');
    // Sentry.captureException(
    //   Exception('failed to extract extractActivityScore'),
    // );

    return 0;
  }

  return result;
}

StatusColor _parseStatus(dynamic val) {
  switch (val) {
    case 'red':
      return StatusColor.red;
    case 'green':
      return StatusColor.green;
    case 'orange':
      return StatusColor.orange;
    default:
      Logger().w('failed to extract status color: $val');
      Sentry.captureMessage(
        'failed to extract status color',
        params: [val],
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
      return val.map((e) => e.toString()).toList();
      // const errMsg = 'MISSING REPORTS PARSE IMPLEMENTATION LIST';
      // // not suposed to be here but found this during dev so putting it here
      // Sentry.captureMessage(errMsg);
      // Logger().w('$errMsg list', error: val);
    }
  } else if (val is String) {
    const errMsg = 'MISSING REPORTS PARSE IMPLEMENTATION';
    // not suposed to be here but found this during dev so putting it here
    Sentry.captureMessage(errMsg, params: [val]);
    Logger().w(errMsg, error: val);

    return [];
  }

  return [];
}

List<EventDto> _parseEvents(dynamic val) {
  const errMsg = 'MISSING EVENTS PARSE IMPLEMENTATION';

  if (val is List<dynamic>) {
    if (val.isEmpty) {
      return [];
    }

    return val.map((e) => EventDto.fromJson(e)).toList();

    // Logger().w(errMsg);
    // Sentry.captureMessage(errMsg, params: [val]);

    // return [];
  } else if (val is String) {
    // not suposed to be here but found this during dev so putting it here
    Sentry.captureMessage(errMsg, params: [val]);
    Logger().w(errMsg, error: val);

    return [];
  }

  return [];
}

Relationship _extractRelationship(String? val) {
  if (val == Relationship.father.name) {
    return Relationship.father;
  } else if (val == Relationship.mother.name) {
    return Relationship.mother;
  } else if (val == Relationship.brother.name) {
    return Relationship.brother;
  } else if (val == Relationship.sister.name) {
    return Relationship.sister;
  } else if (val == Relationship.husband.name) {
    return Relationship.husband;
  } else if (val == Relationship.wife.name) {
    return Relationship.wife;
  } else if (val == Relationship.other.name) {
    return Relationship.other;
  }

  return Relationship.other;
}

extension ApprenticeX on PersonaDto {
  String get fullName {
    final name = [];
    if (firstName.isNotEmpty) name.add(firstName);
    if (lastName.isNotEmpty) name.add(lastName);
    return name.join(' ');
  }

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
  String get format {
    try {
      return '0${substring(0, 2)}-${substring(2)}';
    } catch (e) {
      return this;
    }
  }
}
