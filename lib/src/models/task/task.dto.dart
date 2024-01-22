import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'task.dto.f.dart';
part 'task.dto.g.dart';

enum TaskType {
  none,
  meeting,
  parentsMeeting,
  groupMeeting,
  call,
}

enum TaskStatus {
  unknown,
  todo,
  done,
}

@JsonSerializable()
@Freezed(fromJson: false)
class TaskDto with _$TaskDto {
  const factory TaskDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String details,
    @Default('') String frequency,
    @Default(TaskStatus.unknown)
    @JsonKey(fromJson: _extractStatus)
    TaskStatus status,
    @Default(TaskType.none)
    @JsonKey(fromJson: _extractTaskType)
    TaskType reportEventType,
    @Default(ApprenticeDto()) ApprenticeDto apprentice,
    @Default('') String dateTime,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}

TaskType _extractTaskType(String? data) {
  switch (data) {
    case 'מפגש_קבוצתי':
      return TaskType.groupMeeting;
    case 'שיחה':
      return TaskType.call;
    case 'מפגש':
      return TaskType.meeting;
    case 'מפגש הורים':
      return TaskType.parentsMeeting;
    default:
      return TaskType.none;
  }
}

TaskStatus _extractStatus(String? data) {
  switch (data) {
    case 'todo':
      return TaskStatus.todo;
    case 'done':
      return TaskStatus.done;
    default:
      return TaskStatus.unknown;
  }
}
