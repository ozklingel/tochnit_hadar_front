import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.dto.f.dart';
part 'address.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AddressDto with _$AddressDto {
  const factory AddressDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String apartment,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String city,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int cityId,
    @Default('')
    @JsonKey(
      name: 'country',
      defaultValue: '',
    )
    String countryCode,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String entrance,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String floor,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String houseNumber,
    @Default(0.0)
    @JsonKey(
      defaultValue: 0,
    )
    double lat,
    @Default(0.0)
    @JsonKey(
      defaultValue: 0,
    )
    double lng,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String postalCode,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String region,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String street,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}

extension AddressX on AddressDto {
  String get fullAddress => '$city $street $houseNumber';
}
