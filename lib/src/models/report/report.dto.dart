import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'report.dto.f.dart';
part 'report.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ReportDto with _$ReportDto {
  const factory ReportDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String description,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'ent_group',
    )
    String group,
    @Default(ReportEventType.none)
    @JsonKey(
      name: 'title',
      fromJson: _extractType,
    )
    ReportEventType reportEventType,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'reported_on',
    )
    List<String> recipients,
    @Default([])
    @JsonKey(
      defaultValue: [],
    )
    List<String> attachments,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'allreadyread',
    )
    String allreadyRead,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String dateTime,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'days_from_now',
    )
    int daysFromNow,
  }) = _ReportDto;

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);
}

// List<String> _extractFrom(List<dynamic> data) {
//   return data.map((e) => e.toString()).toList();
// }

enum ReportEventType {
  none,
  offlineMeeting, // מפגש
  offlineGroupMeeting, // מפגש קבוצתי
  periodInput, // הזנת מחזור
  mosadMeetings, // ישיבה מוסדית
  onlineMeeting,
  recurringMeeting, // מפגש מחזור
  matsbarGathering, // ישיבת מצב”ר
  call, // שיחה
  callParents, // שיחה להורים
  baseVisit, // ביקור בבסיס
  recurringSabath, // שבת מחזור
  fiveMessages,
  annualConference, // כנס מלווים שנתי
  monthlyProfessionalConference, // כנס מלווים מקצועי חודשי
  doingForAlumni, // עשיה לבוגרים
  adminsGathering, // ישיבת רכזי תוכנית
  failedAttempt, // נסיון שכשל
  sevenMsgs, // נסיון שכשל
  sixMsgs, // נסיון שכשל
  other;

  String get name {
    switch (this) {
      case ReportEventType.none:
        return 'אין';
      case ReportEventType.offlineMeeting:
        return 'פגישה פיזית';
      case ReportEventType.onlineMeeting:
        return 'פגישה מקוונת';
      case ReportEventType.call:
        return 'שיחה טלפונית';
      case ReportEventType.callParents:
        return 'שיחה להורים';
      case ReportEventType.fiveMessages:
        return '5 הודעות';
      case ReportEventType.failedAttempt:
        return 'נסיון כושל';
      case ReportEventType.recurringMeeting:
        return 'מפגש מחזור';
      case ReportEventType.matsbarGathering:
        return 'ישיבת מצב”ר';
      case ReportEventType.baseVisit:
        return 'ביקור בבסיס';
      case ReportEventType.recurringSabath:
        return 'שבת מחזור';
      case ReportEventType.annualConference:
        return 'כנס מלווים שנתי';
      case ReportEventType.monthlyProfessionalConference:
        return 'כנס מלווים מקצועי חודשי';
      case ReportEventType.doingForAlumni:
        return 'עשיה לבוגרים';
      case ReportEventType.adminsGathering:
        return 'ישיבת רכזי תוכנית';
      case ReportEventType.offlineGroupMeeting:
        return 'מפגש קבוצתי';
      case ReportEventType.periodInput:
        return 'הזנת מחזור';
      case ReportEventType.mosadMeetings:
        return 'ישיבה מוסדית';
      case ReportEventType.sevenMsgs:
        return '7 הודעות';
      case ReportEventType.sixMsgs:
        return '6 הודעות';
      case ReportEventType.other:
        return 'UNKNOWN TYPE';
    }
  }
}

ReportEventType _extractType(String? val) {
  if (val == null) {
    return ReportEventType.none;
  }

  val = val.replaceAll('_', ' ');

  if (val == ReportEventType.adminsGathering.name) {
    return ReportEventType.adminsGathering;
  } else if (val == ReportEventType.annualConference.name) {
    return ReportEventType.annualConference;
  } else if (val == ReportEventType.baseVisit.name) {
    return ReportEventType.baseVisit;
  } else if (val == ReportEventType.doingForAlumni.name) {
    return ReportEventType.doingForAlumni;
  } else if (val == ReportEventType.failedAttempt.name) {
    return ReportEventType.failedAttempt;
  } else if (val == ReportEventType.fiveMessages.name) {
    return ReportEventType.fiveMessages;
  } else if (val == ReportEventType.matsbarGathering.name) {
    return ReportEventType.matsbarGathering;
  } else if (val == ReportEventType.monthlyProfessionalConference.name) {
    return ReportEventType.monthlyProfessionalConference;
  } else if (val == ReportEventType.offlineMeeting.name) {
    return ReportEventType.offlineMeeting;
  } else if (val == ReportEventType.offlineGroupMeeting.name) {
    return ReportEventType.offlineGroupMeeting;
  } else if (val == ReportEventType.onlineMeeting.name) {
    return ReportEventType.onlineMeeting;
  } else if (val == ReportEventType.call.name) {
    return ReportEventType.call;
  } else if (val == ReportEventType.recurringMeeting.name) {
    return ReportEventType.recurringMeeting;
  } else if (val == ReportEventType.recurringSabath.name) {
    return ReportEventType.recurringSabath;
  } else if (val == ReportEventType.sevenMsgs.name) {
    return ReportEventType.sevenMsgs;
  } else if (val == ReportEventType.sixMsgs.name) {
    return ReportEventType.sixMsgs;
  } else {
    const err = 'failed to extract report type';
    Logger().i(err, error: val);
    Sentry.captureException(Exception(err));
    Toaster.error(err);

    return ReportEventType.other;
  }
}
