import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'notification.dto.f.dart';
part 'notification.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class NotiDto with _$NotiDto {
  const factory NotiDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String content,
    @Default(ApprenticeDto()) ApprenticeDto from,
    @Default([]) List<String> attachments,
    // in milliseconds since epoch
    @Default(0) int dateTime,
  }) = _NotiDto;

  factory NotiDto.fromJson(Map<String, dynamic> json) =>
      _$NotiDtoFromJson(json);
}
