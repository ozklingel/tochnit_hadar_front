import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.dto.f.dart';
part 'address.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AddressDto with _$AddressDto {
  const factory AddressDto({
    @Default('') String city,
    @Default('') String street,
    @Default('') String houseNumber,
    @Default('') String apartment,
    @Default('') String region,
    @Default('') String entrance,
    @Default('') String floor,
    @Default('') String postalCode,
    @Default(0) double lat,
    @Default(0) double lng,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}

extension AddressX on AddressDto {
  String get fullAddress => '$city, $street $houseNumber';
}
