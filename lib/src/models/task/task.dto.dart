import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'task.dto.f.dart';
part 'task.dto.g.dart';

enum TaskType {
  none,
  meeting,
  meetingParents,
  meetingGroup,
  meetingPeriod,
  meetingMatsbar,
  call,
  callParents,
  failedAttempt,
  xMessages,
  forgottenApprentices,
  baseVisit,
  hazanatMahzor,
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
      fromJson: _extractTaskType,
    )
    TaskType event,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'subject',
    )
    List<String> subject,
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
    case 'meetingGroup':
      return TaskType.meetingGroup;
    case 'מפגש מחזור':
    case 'meetingPeriod':
      return TaskType.meetingPeriod;
    case 'שיחה':
    case 'שיחה טלפונית':
    case 'call':
      return TaskType.call;
    case 'שיחת הורים':
    case 'שיחת_הורים':
    case 'שיחה להורים':
    case 'callParents':
      return TaskType.callParents;
    case 'מפגש':
    case 'פגישה פיזית':
    case 'meeting':
      return TaskType.meeting;
    case 'מפגש הורים':
    case 'מפגש_הורים':
    case 'meetingParents':
      return TaskType.meetingParents;
    case 'נסיון כושל':
    case 'failedAttempt':
      return TaskType.failedAttempt;
    case '6 הודעות':
    case 'xMessages':
      return TaskType.xMessages;
    case 'חניכים נשכחים':
    case 'forgottenApprentices':
      return TaskType.forgottenApprentices;
    case 'ביקור בבסיס':
    case 'baseVisit':
      return TaskType.baseVisit;
    case 'ישיבת מצב”ר':
    case 'meetingMatsbar':
      return TaskType.meetingMatsbar;
    case 'הזנת מחזור':
    case 'hazanatMahzor':
      return TaskType.hazanatMahzor;
    default:
      const msg = 'failed to extract task type';
      Logger().d(
        msg,
        error: data,
      );
      Sentry.captureEvent(
        SentryEvent(
          message: SentryMessage(
            msg,
            params: [data],
          ),
        ),
      );

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
