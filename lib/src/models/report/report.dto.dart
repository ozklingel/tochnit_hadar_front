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
    @Default(Event.other)
    @JsonKey(
      name: 'title',
      fromJson: _extractType,
    )
    Event event,
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
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String search,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'creation_date',
    )
    String creationDate,
  }) = _ReportDto;

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);
}

// List<String> _extractFrom(List<dynamic> data) {
//   return data.map((e) => e.toString()).toList();
// }

enum Event {
  offlineMeeting(100), // מפגש
  offlineGroupMeeting(101), // מפגש קבוצתי
  onlineMeeting(102),
  call(103), // שיחה
  callParents(104), // שיחה להורים
  baseVisit(105), // ביקור בבסיס
  fiveMessages(106),
  failedAttempt(107), // נסיון שכשל
  // melave
  matsbarGathering(200), // ישיבת מצב”ר
  recurringSabath(201), // שבת מחזור
  doingForAlumni(202), // עשיה לבוגרים
  monthlyProfessionalConference(203), // כנס מלווים מקצועי חודשי
  periodInput(204), // הזנת מחזור
  recurringMeeting(205), // מפגש מחזור
  mosadMeetings(206), // ישיבה מוסדית
  // rakaz mosad
  annualConference(300), // כנס מלווים שנתי
  adminsGathering(301), // ישיבת רכזי תוכנית
  // rakz eshkol
  // ahrai tohnit
  other(999);

  const Event(this.val);

  final int val;

  String get enumName => toString().split('.').last;

  String get name {
    switch (this) {
      case Event.offlineMeeting:
        return 'פגישה פיזית';
      case Event.offlineGroupMeeting:
        return 'מפגש קבוצתי';
      case Event.onlineMeeting:
        return 'פגישה מקוונת';
      case Event.call:
        return 'שיחה טלפונית';
      case Event.callParents:
        return 'שיחה להורים';
      case Event.baseVisit:
        return 'ביקור בבסיס';
      case Event.fiveMessages:
        return '5 הודעות';
      case Event.failedAttempt:
        return 'נסיון כושל';
      // end melave
      case Event.matsbarGathering:
        return 'ישיבת מצב”ר';
      case Event.recurringSabath:
        return 'שבת מחזור';
      case Event.doingForAlumni:
        return 'עשיה לבוגרים';
      case Event.monthlyProfessionalConference:
        return 'כנס מלווים מקצועי חודשי';
      case Event.periodInput:
        return 'הזנת מחזור';
      case Event.recurringMeeting:
        return 'מפגש מחזור';
      case Event.mosadMeetings:
        return 'ישיבה מוסדית';
      // end rakaz mosad
      case Event.annualConference:
        return 'כנס מלווים שנתי';
      case Event.adminsGathering:
        return 'ישיבת רכזי תוכנית';
      // end rakaz eshkol
      case Event.other:
        return 'UNKNOWN TYPE';
    }
  }
}

Event _extractType(String? val) {
  // account for bad server data
  val = val?.replaceAll('_', ' ');

  if (val == Event.adminsGathering.name) {
    return Event.adminsGathering;
  } else if (val == Event.annualConference.name) {
    return Event.annualConference;
  } else if (val == Event.baseVisit.name) {
    return Event.baseVisit;
  } else if (val == Event.doingForAlumni.name) {
    return Event.doingForAlumni;
  } else if (val == Event.failedAttempt.name) {
    return Event.failedAttempt;
  } else if (val == Event.fiveMessages.name ||
      (val?.contains(' הודעות') ?? false)) {
    return Event.fiveMessages;
  } else if (val == Event.matsbarGathering.name) {
    return Event.matsbarGathering;
  } else if (val == Event.monthlyProfessionalConference.name) {
    return Event.monthlyProfessionalConference;
  } else if (val == Event.offlineMeeting.name) {
    return Event.offlineMeeting;
  } else if (val == Event.offlineGroupMeeting.name) {
    return Event.offlineGroupMeeting;
  } else if (val == Event.onlineMeeting.name) {
    return Event.onlineMeeting;
  } else if (val == Event.call.name || val == 'שיחה') {
    return Event.call;
  } else if (val == Event.callParents.name) {
    return Event.callParents;
  } else if (val == Event.periodInput.name) {
    return Event.periodInput;
  } else if (val == Event.recurringMeeting.name) {
    return Event.recurringMeeting;
  } else if (val == Event.recurringSabath.name) {
    return Event.recurringSabath;
  } else {
    const err = 'failed to extract report type';
    Logger().i(err, error: val);
    Sentry.captureException(Exception(err));
    Toaster.error(err);

    return Event.other;
  }
}
