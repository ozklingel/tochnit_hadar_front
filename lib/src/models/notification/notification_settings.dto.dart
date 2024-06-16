import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.dto.f.dart';
part 'notification_settings.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class NotificationSettingsDto with _$NotificationSettingsDto {
  const factory NotificationSettingsDto({
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyDayBefore',
    )
    bool notifyDayBefore,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyDayBefore_sevev',
    )
    bool notifyDayBeforeSevev,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyMorning',
    )
    bool notifyMorning,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyMorning_sevev',
    )
    bool notifyMorningSevev,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyMorning_weekly_report',
    )
    bool notifyMorningWeeklyReport,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyStartWeek',
    )
    bool notifyStartWeek,
    @Default(false)
    @JsonKey(
      defaultValue: false,
      name: 'notifyStartWeek_sevev',
    )
    bool notifyStartWeekSevev,
  }) = _NotificationSettingsDto;

  factory NotificationSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsDtoFromJson(json);
}
