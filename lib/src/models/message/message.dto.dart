import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String content,
    @Default('') String from,
    @Default('') String icon,
    @Default(false)
    @JsonKey(name: 'allreadyread', fromJson: _extractIsAlreadyRead)
    bool allreadyRead,
    @Default([]) List<String> attachments,
    @Default('') @JsonKey(name: 'date') String dateTime,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
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
