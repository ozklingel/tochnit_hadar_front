import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.dto.f.dart';
part 'address.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AddressDto with _$AddressDto {
  const factory AddressDto({
    @Default('') String apartment,
    @Default('') String city,
    @Default(0) int cityId,
    @Default('') @JsonKey(name: 'country') String countryCode,
    @Default('') String entrance,
    @Default('') String floor,
    @Default('') String houseNumber,
    @Default(0.0) double lat,
    @Default(0.0) double lng,
    @Default('') String postalCode,
    @Default('') String region,
    @Default('') String street,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}

extension AddressX on AddressDto {
  String get fullAddress => '$city $street $houseNumber';
}
