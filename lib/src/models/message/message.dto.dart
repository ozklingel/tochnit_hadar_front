import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'message.dto.f.dart';
part 'message.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @Default('') String id,
    @Default(ApprenticeDto()) ApprenticeDto from,
    @Default('') String title,
    @Default('') String content,
    @Default([]) List<String> attachments,
    // in milliseconds since epoch
    @Default(0) int dateTime,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
