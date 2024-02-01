import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';

part 'flags.dto.f.dart';
part 'flags.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class FlagsDto with _$FlagsDto {
  const factory FlagsDto({
    @Default(false) bool isMock,
    @Default(UserDto()) UserDto user,
    @Default([]) List<ApprenticeDto> apprentices,
    @Default([]) List<Map<String, dynamic>> notifications,
    @Default([]) List<MessageDto> messages,
    @Default([]) List<TaskDto> tasks,
    @Default([]) List<ReportDto> reports,
  }) = _FlagsDto;

  factory FlagsDto.fromJson(Map<String, dynamic> json) =>
      _$FlagsDtoFromJson(json);
}
