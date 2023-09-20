import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'task.dto.f.dart';
part 'task.dto.g.dart';

enum TaskType {
  none,
  meeting,
  call,
  parents,
}

@JsonSerializable()
@Freezed(fromJson: false)
class TaskDto with _$TaskDto {
  const factory TaskDto({
    @Default('') String id,
    @Default(TaskType.none) TaskType reportEventType,
    @Default(ApprenticeDto()) ApprenticeDto apprentices,
    // InMsSinceEpoch
    @Default(0) int dateTime,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}
