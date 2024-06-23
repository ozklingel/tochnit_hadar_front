import 'package:freezed_annotation/freezed_annotation.dart';

part 'apprentice_status.dto.f.dart';
part 'apprentice_status.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ApprenticeStatusDto with _$ApprenticeStatusDto {
  const factory ApprenticeStatusDto({
    @Default(0)
    @JsonKey(
      name: 'lowScoreApprentice_Count',
      defaultValue: 0,
    )
    int generalApprenticeCount,
    @Default([])
    @JsonKey(
      name: 'lowScoreApprentice_List',
      defaultValue: [],
    )
    List<ApprenticeStatusItemDto> generalApprentices,
    @Default(0)
    @JsonKey(
      name: 'missingCallApprentice_total',
      defaultValue: 0,
    )
    int missingCallApprenticeCount,
    @Default([])
    @JsonKey(
      name: 'missingCalleApprentice_count',
      defaultValue: [],
    )
    List<ApprenticeStatusItemDto> missingCallApprentices,
    @Default(0)
    @JsonKey(
      name: 'missingmeetApprentice_total',
      defaultValue: 0,
    )
    int missingMeetApprenticeCount,
    @Default([])
    @JsonKey(
      name: 'missingmeetApprentice_count',
      defaultValue: [],
    )
    List<ApprenticeStatusItemDto> missingMeetApprentices,
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
    String name,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int value,
  }) = _ApprenticeStatusItemDto;

  factory ApprenticeStatusItemDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeStatusItemDtoFromJson(json);
}
