import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

enum MessageType {
  draft,
  customerService,
  sent,
  other,
}

@JsonSerializable()
@Freezed(fromJson: false)
class MessageDto with _$MessageDto {
  const factory MessageDto({
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
    @Default(MessageType.other)
    @JsonKey(
      fromJson: _extractMessageType,
    )
    MessageType type,
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
    @Default([])
    @JsonKey(
      defaultValue: [],
    )
    List<String> to,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

MessageType _extractMessageType(String? data) {
  switch (data) {
    case 'פניות_שירות':
      return MessageType.customerService;
    case 'draft':
      return MessageType.draft;
    case 'sent':
      return MessageType.sent;
    default:
      return MessageType.other;
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
