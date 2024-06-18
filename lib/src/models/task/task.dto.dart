import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';

part 'task.dto.f.dart';
part 'task.dto.g.dart';

enum TaskStatus {
  unknown,
  todo,
  done,
}

enum TaskFrequencyMeta {
  once,
  daily,
  weekly,
  monthly,
  yearly,
  custom,
  unknown,
}

enum TaskFrequencyEnd {
  once,
  forever,
  one,
  two,
  three,
  four,
  unknown;

  String get name {
    switch (this) {
      case once:
        return 'once';
      case forever:
        return 'forever';
      case one:
        return '1';
      case two:
        return '2';
      case three:
        return '3';
      case four:
        return '4';
      default:
        return 'unknown';
    }
  }
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
    @Default(TaskFrequencyMeta.unknown)
    @JsonKey(
      fromJson: _extractFrequencyMeta,
      name: 'frequency_meta',
    )
    TaskFrequencyMeta frequencyMeta,
    @Default(TaskFrequencyEnd.unknown)
    @JsonKey(
      fromJson: _extractFrequencyEnd,
      name: 'frequency_end',
    )
    TaskFrequencyEnd frequencyEnd,
    @Default(TaskStatus.unknown)
    @JsonKey(fromJson: _extractStatus)
    TaskStatus status,
    @Default(Event.other)
    @JsonKey(
      fromJson: extractEventType,
    )
    Event event,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'subject',
      fromJson: _extractSubject,
    )
    List<String> subject,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String dateTime,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'allreadyread',
    )
    bool alreadyRead,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}

List<String> _extractSubject(dynamic data) {
  // This handles bad server data (i.e. the data is a just a string)
  final listData = data is! List<dynamic> ? [data] : data;
  return (listData as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
}

TaskFrequencyMeta _extractFrequencyMeta(String? data) {
  switch (data) {
    case 'once':
      return TaskFrequencyMeta.once;
    case 'daily':
      return TaskFrequencyMeta.daily;
    case 'weekly':
      return TaskFrequencyMeta.weekly;
    case 'monthly':
      return TaskFrequencyMeta.monthly;
    case 'yearly':
      return TaskFrequencyMeta.yearly;
    case 'custom':
      return TaskFrequencyMeta.custom;
    default:
      return TaskFrequencyMeta.unknown;
  }
}

TaskFrequencyEnd _extractFrequencyEnd(String? data) {
  switch (data) {
    case 'forever':
      return TaskFrequencyEnd.forever;
    case '1':
      return TaskFrequencyEnd.one;
    case '2':
      return TaskFrequencyEnd.two;
    case '3':
      return TaskFrequencyEnd.three;
    case '4':
      return TaskFrequencyEnd.four;
    case 'once':
      return TaskFrequencyEnd.once;
    default:
      return TaskFrequencyEnd.unknown;
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
