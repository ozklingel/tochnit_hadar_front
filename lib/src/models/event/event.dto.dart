import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';

part 'event.dto.f.dart';
part 'event.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class EventDto with _$EventDto {
  const EventDto._();

  const factory EventDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
      // name: 'event',
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

  bool get isBirthday => title == 'יום הולדת';

  bool get isDateRelevant =>
      DateTime.now()
          .isBefore(datetime.asDateTime.add(const Duration(days: 2))) &&
      DateTime.now().isAfter(
        datetime.asDateTime.subtract(Duration(days: isBirthday ? 30 : 14)),
      );
}
