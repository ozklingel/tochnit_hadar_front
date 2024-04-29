import 'package:freezed_annotation/freezed_annotation.dart';

part 'apprentice_status.dto.f.dart';
part 'apprentice_status.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeStatusDto with _$ApprenticeStatusDto {
  const factory ApprenticeStatusDto({
    @Default(0)
    @JsonKey(
      name: 'forgotenApprentice_total',
      defaultValue: 0,
    )
    int total,
    @Default([])
    @JsonKey(
      name: 'forgotenApprentice_count',
      defaultValue: [],
    )
    List<ApprenticeStatusItemDto> items,
  }) = _ApprenticeStatusDto;

  factory ApprenticeStatusDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeStatusDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeStatusItemDto with _$ApprenticeStatusItemDto {
  const factory ApprenticeStatusItemDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int value,
  }) = _ApprenticeStatusItemDto;

  factory ApprenticeStatusItemDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeStatusItemDtoFromJson(json);
}
