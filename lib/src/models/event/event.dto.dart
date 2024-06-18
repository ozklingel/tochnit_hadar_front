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
      name: 'allreadyread',
      fromJson: _extractDynamicToString,
    )
    String isAlreadyRead,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'created_at',
    )
    String createdAt,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date',
    )
    String datetime,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'daysfromnow',
    )
    int daysFromNow,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String description,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'event',
    )
    String eventType,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String frequency,
    @Default('')
    @JsonKey(
      defaultValue: '',
      fromJson: _extractDynamicToString,
    )
    String id,
    @Default(1)
    @JsonKey(
      defaultValue: 1,
    )
    int numOfLinesDisplay,
    @Default('')
    @JsonKey(
      fromJson: _extractDynamicToString,
    )
    String subject,
  }) = _EventDto;

  // ignore: unused_element
  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  bool get isBirthday => eventType == 'יומהולדת';

  bool get isDateRelevant =>
      DateTime.now()
          .isBefore(datetime.asDateTime.add(const Duration(days: 2))) &&
      DateTime.now().isAfter(
        datetime.asDateTime.subtract(Duration(days: isBirthday ? 30 : 14)),
      );
}

// this should be done properly from backend but i'm so tired of the back and forth
String _extractDynamicToString(dynamic data) {
  return data.toString();
}
