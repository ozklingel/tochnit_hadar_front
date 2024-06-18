import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.dto.f.dart';
part 'notification_settings.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class NotificationSettingsDto with _$NotificationSettingsDto {
  const factory NotificationSettingsDto({
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyDayBefore',
    )
    bool notifyDayBefore,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyDayBefore_sevev',
    )
    bool notifyDayBeforeSevev,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyMorning',
    )
    bool notifyMorning,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyMorning_sevev',
    )
    bool notifyMorningSevev,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyMorning_weekly_report',
    )
    bool notifyMorningWeeklyReport,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyStartWeek',
    )
    bool notifyStartWeek,
    @Default(false)
    @JsonKey(
      fromJson: _parseValue,
      name: 'notifyStartWeek_sevev',
    )
    bool notifyStartWeekSevev,
  }) = _NotificationSettingsDto;

  factory NotificationSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsDtoFromJson(json);
}

bool _parseValue(dynamic data) {
  if (data is bool?) {
    if (data != null) {
      return data;
    }
  }

  if (data?.toString().toLowerCase() == 'true') {
    return true;
  }

  return false;
}
