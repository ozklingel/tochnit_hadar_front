import 'package:freezed_annotation/freezed_annotation.dart';

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

enum TaskFrequency {
  once,
  daily,
  weekly,
  monthly,
  yearly,
  custom,
  unknown,
}

@JsonSerializable()
@Freezed(fromJson: false)
class TaskDto with _$TaskDto {
  const factory TaskDto({
    @Default('') String id,
    @Default('') @JsonKey(name: 'description') String details,
    @Default(TaskFrequency.unknown)
    @JsonKey(fromJson: _extractFrequency)
    TaskFrequency frequency,
    @Default(TaskStatus.unknown)
    @JsonKey(fromJson: _extractStatus)
    TaskStatus status,
    @Default(TaskType.none)
    @JsonKey(
      name: 'title',
      fromJson: _extractTaskType,
    )
    TaskType reportEventType,
    @Default([]) @JsonKey(name: 'apprenticeId') List<String> apprenticeIds,
    @Default('') @JsonKey(name: 'date') String dateTime,
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

TaskFrequency _extractFrequency(String? data) {
  switch (data) {
    case 'once':
      return TaskFrequency.once;
    case 'daily':
      return TaskFrequency.daily;
    case 'weekly':
      return TaskFrequency.weekly;
    case 'monthly':
      return TaskFrequency.monthly;
    case 'yearly':
      return TaskFrequency.yearly;
    case 'custom':
      return TaskFrequency.custom;
    default:
      return TaskFrequency.unknown;
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
