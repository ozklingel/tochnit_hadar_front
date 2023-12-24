import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.dto.f.dart';
part 'report.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ReportDto with _$ReportDto {
  const factory ReportDto({
    @Default('') String id,
    @Default('') String description,
    @Default(ReportEventType.none) ReportEventType reportEventType,
    @Default([]) List<String> apprentices,
    @Default([]) List<String> attachments,
    @Default('') @JsonKey(name: 'allreadyread') String allreadyRead,
    // in milliseconds since epoch
    @Default('') String dateTime,
  }) = _ReportDto;

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);
}

enum ReportEventType {
  none,
  offlineMeeting, // מפגש
  onlineMeeting,
  recurringMeeting, // מפגש מחזור
  matsbarGathering, // ישיבת מצב”ר
  phoneCall, // שיחה
  baseVisit, // ביקור בבסיס
  recurringSabath, // שבת מחזור
  fiveMessages,
  annualConference, // כנס מלווים שנתי
  monthlyProfessionalConference, // כנס מלווים מקצועי חודשי
  doingForAlumni, // עשיה לבוגרים
  adminsGathering, // ישיבת רכזי תוכנית
  failedAttempt // נסיון שכשל
  ;

  String get name {
    switch (this) {
      case ReportEventType.none:
        return 'אין';
      case ReportEventType.offlineMeeting:
        return 'פגישה פיזית';
      case ReportEventType.onlineMeeting:
        return 'פגישה מקוונת';
      case ReportEventType.phoneCall:
        return 'שיחה טלפונית';
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
    }
  }
}
