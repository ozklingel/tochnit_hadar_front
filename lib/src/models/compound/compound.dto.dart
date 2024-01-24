import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';

part 'compound.dto.f.dart';
part 'compound.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class CompoundDto with _$CompoundDto {
  const factory CompoundDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String name,
    @Default(AddressDto()) AddressDto address,
  }) = _CompoundDto;

  factory CompoundDto.fromJson(Map<String, dynamic> json) =>
      _$CompoundDtoFromJson(json);
}
