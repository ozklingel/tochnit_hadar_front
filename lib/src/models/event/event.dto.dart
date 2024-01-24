import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.dto.f.dart';
part 'event.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class EventDto with _$EventDto {
  const factory EventDto({
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
    String description,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String datetime,
  }) = _EventDto;

  // ignore: unused_element
  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}
