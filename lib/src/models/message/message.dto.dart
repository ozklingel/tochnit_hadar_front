import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @Default('')
    @JsonKey(
      includeIfNull: true,
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      includeIfNull: true,
      defaultValue: '',
    )
    String title,
    @Default('')
    @JsonKey(
      includeIfNull: true,
      defaultValue: '',
    )
    String content,
    @Default('')
    @JsonKey(
      includeIfNull: true,
      defaultValue: '',
    )
    String from,
    @Default('')
    @JsonKey(
      includeIfNull: true,
      defaultValue: '',
    )
    String icon,
    @Default('')
    @JsonKey(
      name: 'allreadyread',
      defaultValue: '',
    )
    String allreadyRead,
    @Default([])
    @JsonKey(
      includeIfNull: true,
      defaultValue: [],
    )
    List<String> attachments,
    // in milliseconds since epoch
    @Default(0)
    @JsonKey(
      includeIfNull: true,
      defaultValue: 0,
    )
    int dateTime,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
