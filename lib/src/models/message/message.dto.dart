import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

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
