import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgotten_mosad_apprentices.dto.f.dart';
part 'forgotten_mosad_apprentices.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ForgottenMosadApprenticesDto with _$ForgottenMosadApprenticesDto {
  const factory ForgottenMosadApprenticesDto({
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int percentage,
    @Default([])
    @JsonKey(
      name: 'apprentice_list',
      defaultValue: [],
    )
    List<ForgottenMosadApprenticeItemDto> items,
  }) = _ForgottenMosadApprenticesDto;

  factory ForgottenMosadApprenticesDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenMosadApprenticesDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class ForgottenMosadApprenticeItemDto with _$ForgottenMosadApprenticeItemDto {
  const factory ForgottenMosadApprenticeItemDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
      fromJson: _extractId,
    )
    String id,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int gap,
  }) = _ForgottenMosadApprenticeItemDto;

  factory ForgottenMosadApprenticeItemDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenMosadApprenticeItemDtoFromJson(json);
}

String _extractId(dynamic val) {
  return val.toString();
}
