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
      fromJson: extractEventType,
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
  // melave
  meeting(100), // מפגש
  groupMeeting(101), // מפגש קבוצתי
  onlineMeeting(102),
  call(103), // שיחה
  callParents(104), // שיחה להורים
  meetingParents(105), // מפגש הורים
  baseVisit(106), // ביקור בבסיס
  fiveMessages(107),
  failedAttempt(108), // נסיון שכשל
  birthday(109), // יום הולדת
  forgottenApprentices(110), // חניכים נשכחים
  // rakaz mosad
  matsbarGathering(200), // ישיבת מצב”ר
  recurringSabbath(201), // שבת מחזור
  doingForAlumni(202), // עשיה לבוגרים
  monthlyProfessionalConference(203), // כנס מלווים מקצועי חודשי
  periodInput(204), // הזנת מחזור
  recurringMeeting(205), // מפגש מחזור
  mosadMeetings(206), // ישיבה מוסדית
  // rakz eshkol
  annualConference(300), // כנס מלווים שנתי
  adminsGathering(301), // ישיבת רכזי תוכנית
  coordinatorMeeting(302), // ישיבת רכז
  // ahrai tohnit
  monthlyProgramMeeting(400), // ישיבת תוכנית חודשית
  other(999);

  const Event(this.val);

  final int val;

  String get enumName => toString().split('.').last;

  String get name {
    switch (this) {
      // melave
      case Event.meeting:
        return 'פגישה פיזית';
      case Event.groupMeeting:
        return 'מפגש קבוצתי';
      case Event.onlineMeeting:
        return 'פגישה מקוונת';
      case Event.call:
        return 'שיחה טלפונית';
      case Event.callParents:
        return 'שיחה להורים';
      case Event.meetingParents:
        return 'מפגש הורים';
      case Event.baseVisit:
        return 'ביקור בבסיס';
      case Event.fiveMessages:
        return '5 הודעות';
      case Event.failedAttempt:
        return 'נסיון כושל';
      case Event.birthday:
        return 'יום הולדת';
      case Event.forgottenApprentices:
        return 'חניכים נשכחים';
      // rakaz mosad
      case Event.matsbarGathering:
        return 'ישיבת מצב”ר';
      case Event.recurringSabbath:
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
      // rakaz eshkol
      case Event.annualConference:
        return 'כנס מלווים שנתי';
      case Event.adminsGathering:
        return 'ישיבת רכזי תוכנית';
      case Event.coordinatorMeeting:
        return 'ישיבה רכז';
      // ahrai tohnit
      case Event.monthlyProgramMeeting:
        return 'ישיבת תוכנית חודשית';
      case Event.other:
        return 'UNKNOWN TYPE';
    }
  }

  bool get isCall => this == call;
  bool get isMeeting => this == meeting || this == groupMeeting;
  bool get isParents => this == meetingParents || this == callParents;
}

Event extractEventType(String? val) {
  // account for bad server data
  val = val?.replaceAll('_', ' ');

  for (final event in Event.values) {
    if (event.name == val) return event;
  }
  if (val?.contains(' הודעות') ?? false) return Event.fiveMessages;
  if (val == 'שיחה') return Event.call;
  if (val == 'none') return Event.other;

  const err = 'failed to extract report type';
  Logger().i(err, error: val);
  Sentry.captureException(Exception(err));
  Toaster.error(err);

  return Event.other;
}
