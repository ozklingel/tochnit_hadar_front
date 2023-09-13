import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'report.dto.f.dart';
part 'report.dto.g.dart';

enum ReportEventType {
  none,
  offlineMeeting,
  onlineMeeting,
  phoneCall,
  fiveMessages,
  failedAttempt,
}

@JsonSerializable()
@Freezed()
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
