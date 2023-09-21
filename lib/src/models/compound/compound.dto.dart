import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'compound.dto.f.dart';
part 'compound.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class CompoundDto with _$CompoundDto {
  const factory CompoundDto({
    @Default('') String id,
    @Default('') String name,
    @Default(0) double lat,
    @Default(0) double lng,
    @Default(AddressDto()) AddressDto address,
    @Default([]) List<ApprenticeDto> apprentices,
  }) = _CompoundDto;

  factory CompoundDto.fromJson(Map<String, dynamic> json) =>
      _$CompoundDtoFromJson(json);
}
