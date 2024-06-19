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
    List<ForgottenApprenticeDto> items,
  }) = _ForgottenMosadApprenticesDto;

  factory ForgottenMosadApprenticesDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenMosadApprenticesDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class ForgottenApprenticeDto with _$ForgottenApprenticeDto {
  const factory ForgottenApprenticeDto({
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
  }) = _ForgottenApprenticeDto;

  factory ForgottenApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ForgottenApprenticeDtoFromJson(json);
}

String _extractId(dynamic val) {
  return val.toString();
}
