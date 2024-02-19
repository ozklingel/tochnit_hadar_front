import 'package:freezed_annotation/freezed_annotation.dart';

part 'hativa.dto.f.dart';
part 'hativa.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class HativaDto with _$HativaDto {
  const factory HativaDto({
    @Default('') @JsonKey(defaultValue: '') String id,
    @Default('') @JsonKey(defaultValue: '') String name,
  }) = _HativaDto;

  factory HativaDto.fromJson(Map<String, dynamic> json) =>
      _$HativaDtoFromJson(json);
}
