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
    @Default('') String title,
    @Default('') String details,
    @Default('') String frequency,
    @Default(false) bool isComplete,
    @Default(TaskType.none) TaskType reportEventType,
    @Default(ApprenticeDto()) ApprenticeDto apprentice,
    // InMsSinceEpoch
    @Default('') String dateTime,
  }) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}
