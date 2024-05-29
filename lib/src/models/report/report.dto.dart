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
  // melave
  offlineMeeting(100), // מפגש
  offlineGroupMeeting(101), // מפגש קבוצתי
  onlineMeeting(102),
  call(103), // שיחה
  callParents(104), // שיחה להורים
  baseVisit(105), // ביקור בבסיס
  fiveMessages(106),
  failedAttempt(107), // נסיון שכשל
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
}

Event _extractType(String? val) {
  // account for bad server data
  val = val?.replaceAll('_', ' ');

  for (final event in Event.values) {
    if (event.name == val) return event;
  }
  if (val?.contains(' הודעות') ?? false) return Event.fiveMessages;
  if (val == 'שיחה') return Event.call;

  const err = 'failed to extract report type';
  Logger().i(err, error: val);
  Sentry.captureException(Exception(err));
  Toaster.error(err);

  return Event.other;
}
