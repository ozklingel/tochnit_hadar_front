import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.dto.f.dart';
part 'event.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class EventDto with _$EventDto {
  const factory EventDto({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int dateTime,
  }) = _EventDto;

  // ignore: unused_element
  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}
