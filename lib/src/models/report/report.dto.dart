import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
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
  beretMarch(111), // מסע כומתה
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

  String get name => switch (this) {
        // melave
        meeting => "פגישה פיזית",
        groupMeeting => "מפגש קבוצתי",
        onlineMeeting => "פגישה מקוונת",
        call => "שיחה טלפונית",
        callParents => "שיחה להורים",
        meetingParents => "מפגש הורים",
        baseVisit => "ביקור בבסיס",
        fiveMessages => "5 הודעות",
        failedAttempt => "נסיון כושל",
        birthday => "יום הולדת",
        forgottenApprentices => "חניכים נשכחים",
        beretMarch => "מסע כומתה",
        // rakaz mosad
        matsbarGathering => "ישיבת מצב”ר",
        recurringSabbath => "שבת מחזור",
        doingForAlumni => "עשיה לבוגרים",
        monthlyProfessionalConference => "כנס מלווים מקצועי חודשי",
        periodInput => "הזנת מחזור",
        recurringMeeting => "מפגש מחזור",
        mosadMeetings => "ישיבה מוסדית",
        // rakaz eshkol
        annualConference => "כנס מלווים שנתי",
        adminsGathering => "ישיבת רכזי תוכנית",
        coordinatorMeeting => "ישיבה רכז",
        // ahrai tohnit
        monthlyProgramMeeting => "ישיבת תוכנית חודשית",
        other => "UNKNOWN TYPE",
      };

  IconData get iconData => switch (this) {
        call || callParents => FluentIcons.call_24_regular,
        meeting ||
        meetingParents ||
        groupMeeting ||
        mosadMeetings ||
        recurringMeeting =>
          FluentIcons.people_24_regular,
        fiveMessages => FluentIcons.chat_24_regular,
        _ => FluentIcons.question_24_regular,
      };

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
  if (val?.contains('כומתה') ?? false) return Event.beretMarch;
  if (val == 'שיחה') return Event.call;
  if (val == 'none') return Event.other;

  const err = 'failed to extract report type';
  Logger().i(err, error: val);
  Sentry.captureException(Exception(err));
  Toaster.error(err);

  return Event.other;
}
