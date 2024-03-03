import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.dto.f.dart';
part 'notification.dto.g.dart';

enum NotificationType {
  draft,
  customerService,
  sent,
  other,
}

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
    String title,
    @Default(NotificationType.other)
    @JsonKey(
      fromJson: _extractnotificationType,
    )
    NotificationType type,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String content,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String from,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String icon,
    @Default(false)
    @JsonKey(
      name: 'allreadyread',
      fromJson: _extractIsAlreadyRead,
    )
    bool allreadyRead,
    @Default([])
    @JsonKey(
      defaultValue: [],
    )
    List<String> attachments,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String dateTime,
  }) = _notificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}

NotificationType _extractnotificationType(String? data) {
  switch (data) {
    case 'פניות_שירות':
      return NotificationType.customerService;
    case 'draft':
      return NotificationType.draft;
    case 'sent':
      return NotificationType.sent;
    default:
      return NotificationType.other;
  }
}

bool _extractIsAlreadyRead(String? data) {
  if (data == null) {
    return false;
  }

  if (data.toLowerCase() == 'true') {
    return true;
  }

  if (data.toLowerCase() == 'false') {
    return false;
  }

  return false;
}
