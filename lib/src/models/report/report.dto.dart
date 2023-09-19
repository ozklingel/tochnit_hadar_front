import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:intl/intl.dart';

part 'report.dto.f.dart';
part 'report.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ReportDto with _$ReportDto {
  const factory ReportDto({
    @Default('') String id,
    @Default('') String description,
    @Default(ReportEventType.none) ReportEventType reportEventType,
    @Default([]) List<ApprenticeDto> apprentices,
    @Default([]) List<String> attachments,
    @Default(0) int dateTimeInMsSinceEpoch,
  }) = _ReportDto;

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);
}

enum ReportEventType {
  none,
  offlineMeeting,
  onlineMeeting,
  phoneCall,
  fiveMessages,
  failedAttempt;

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
      default:
        return '';
    }
  }
}

extension ReportFromMillisecondsSinceEpochX on int {
  DateTime get toDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}

extension ReportDateTimeX on DateTime {
  String get toLocalizedString => DateFormat('dd/MM/yy').format(this);
}
