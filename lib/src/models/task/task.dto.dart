import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'task.dto.f.dart';
part 'task.dto.g.dart';

enum TaskType {
  none,
  meeting,
  meetingParents,
  meetingGroup,
  call,
  callParents,
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
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'description',
    )
    String details,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String title,
    @Default(TaskFrequency.unknown)
    @JsonKey(fromJson: _extractFrequency)
    TaskFrequency frequency,
    @Default(TaskStatus.unknown)
    @JsonKey(fromJson: _extractStatus)
    TaskStatus status,
    @Default(TaskType.none)
    @JsonKey(
      name: 'event',
      fromJson: _extractTaskType,
    )
    TaskType reportEventType,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'apprenticeId',
    )
    List<String> apprenticeIds,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String dateTime,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}

TaskType _extractTaskType(String? data) {
  switch (data) {
    case 'מפגש קבוצתי':
    case 'מפגש_קבוצתי':
      return TaskType.meetingGroup;
    case 'שיחה':
    case 'שיחה טלפונית':
      return TaskType.call;
    case 'שיחת הורים':
    case 'שיחת_הורים':
      return TaskType.callParents;
    case 'מפגש':
    case 'פגישה פיזית':
      return TaskType.meeting;
    case 'מפגש הורים':
    case 'מפגש_הורים':
      return TaskType.meetingParents;
    default:
      Logger().d('extract task type fail', error: data);
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
