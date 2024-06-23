import 'package:freezed_annotation/freezed_annotation.dart';

part 'apprentice_status.dto.f.dart';
part 'apprentice_status.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ForgottenApprenticeDto with _$ForgottenApprenticeDto {
  const factory ForgottenApprenticeDto({
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
    List<ForgottenApprenticeItemDto> items,
  }) = _ForgottenApprenticeDto;

  factory ForgottenApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenApprenticeDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class ForgottenApprenticeItemDto with _$ForgottenApprenticeItemDto {
  const factory ForgottenApprenticeItemDto({
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
  }) = _ForgottenApprenticeItem;

  factory ForgottenApprenticeItemDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenApprenticeItemDtoFromJson(json);
}
