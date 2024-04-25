import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

enum MessageType {
  draft,
  customerService,
  sent,
  incoming,
  other,
}

enum MessageMethod {
  sms,
  whatsapp,
  system,
  other;

  String get name {
    switch (this) {
      case sms:
        return 'SMS';
      case whatsapp:
        return 'וואטסאפ';
      case system:
        return 'הודעת מערכת';
      default:
        return 'other?';
    }
  }
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
    @Default(MessageMethod.other)
    @JsonKey(
      fromJson: _extractMessageMethod,
    )
    MessageMethod method,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

MessageMethod _extractMessageMethod(String? data) {
  return MessageMethod.other;
}

MessageType _extractMessageType(String? data) {
  switch (data) {
    case 'פניות_שירות':
    case 'פניות שירות':
      return MessageType.customerService;
    case 'טיוטות':
    case 'טיוטה':
    case 'draft':
      return MessageType.draft;
    case 'יוצאות':
      return MessageType.sent;
    case 'נכנסות':
      return MessageType.incoming;
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
