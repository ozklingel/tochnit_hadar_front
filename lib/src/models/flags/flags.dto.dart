import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/models/message/message.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';

part 'flags.dto.f.dart';
part 'flags.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class FlagsDto with _$FlagsDto {
  const factory FlagsDto({
    @Default(false) bool isMock,
    @Default(AuthDto()) AuthDto user,
    @Default([]) List<PersonaDto> apprentices,
    @Default([]) List<Map<String, dynamic>> notifications,
    @Default([]) List<MessageDto> messages,
    @Default([]) List<TaskDto> tasks,
    @Default([]) List<ReportDto> reports,
    @Default([]) List<InstitutionDto> institutions,
  }) = _FlagsDto;

  factory FlagsDto.fromJson(Map<String, dynamic> json) =>
      _$FlagsDtoFromJson(json);
}
