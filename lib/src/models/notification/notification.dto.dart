import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.dto.f.dart';
part 'notification.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String event,
    @Default(2)
    @JsonKey(
      defaultValue: 2,
    )
    int numOfLinesDisplay,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String subject,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String description,
    @Default('never')
    @JsonKey(
      defaultValue: '',
    )
    String frequency,
    @Default(false)
    @JsonKey(
      name: 'allreadyread',
    )
    bool allreadyRead,
    @Default(1)
    @JsonKey(
      defaultValue: 1,
    )
    int daysfromnow,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String dateTime,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}
