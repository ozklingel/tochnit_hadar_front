import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.dto.f.dart';
part 'notification.dto.g.dart';

enum notificationType {
  draft,
  customerService,
  sent,
  other,
}

@JsonSerializable()
@Freezed(fromJson: false)
class notificationDto with _$notificationDto {
  const factory notificationDto({
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
    @Default(notificationType.other)
    @JsonKey(
      fromJson: _extractnotificationType,
    )
    notificationType type,
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

  factory notificationDto.fromJson(Map<String, dynamic> json) =>
      _$notificationDtoFromJson(json);
}

notificationType _extractnotificationType(String? data) {
  switch (data) {
    case 'פניות_שירות':
      return notificationType.customerService;
    case 'draft':
      return notificationType.draft;
    case 'sent':
      return notificationType.sent;
    default:
      return notificationType.other;
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
