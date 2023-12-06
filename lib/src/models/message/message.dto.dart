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
    @Default('') @JsonKey(name: 'allreadyread') String allreadyRead,
    @Default([]) List<String> attachments,
    // in milliseconds since epoch
    @Default(0) int dateTime,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
