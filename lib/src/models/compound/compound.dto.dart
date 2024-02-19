import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    @Default(0)
    @JsonKey(
      name: 'LAT',
      fromJson: _extractLat,
    )
    double lat,
    @Default(0)
    @JsonKey(
      name: 'LNG',
      fromJson: _extractLng,
    )
    double lng,
  }) = _CompoundDto;

  factory CompoundDto.fromJson(Map<String, dynamic> json) =>
      _$CompoundDtoFromJson(json);
}

extension CompoundDtoX on CompoundDto {
  LatLng get latLng => LatLng(lat, lng);
}

double _extractLat(String? data) {
  if (data == null) {
    return 0;
  }

  return double.tryParse(data) ?? 0;
}

double _extractLng(String? data) {
  if (data == null) {
    return 0;
  }

  return double.tryParse(data) ?? 0;
}

// LatLng _extractCoordinates(String? data) {
//   if (data == null) {
//     return const LatLng(0, 0);
//   }

//   final parts = data.split(' ');

//   final lat = parts[0];
//   final lng = parts[1];

//   final parsedLat = double.tryParse(lat) ?? 0;
//   final parsedLng = double.tryParse(lng) ?? 0;

//   final result = LatLng(parsedLat, parsedLng);

//   return result;
// }
