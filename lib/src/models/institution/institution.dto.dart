import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';

part 'institution.dto.f.dart';
part 'institution.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class InstitutionDto with _$InstitutionDto {
  const factory InstitutionDto({
    @Default('') String id,
    @Default('') String name,
    @Default('') String rakaz,
    @Default('') String rakazPhoneNumber,
    @Default('') String shluha,
    @Default('') String phoneNumber,
    @Default('') String roshMehinaName,
    @Default('') String roshMehinaPhoneNumber,
    @Default('') String menahelAdministrativiName,
    @Default('') String menahelAdministrativiPhoneNumber,
    @Default([]) List<String> melavim,
    @Default([]) List<String> hanihim,
    @Default(0) double score,
    @Default(AddressDto()) AddressDto address,
  }) = _InstitutionDto;

  factory InstitutionDto.fromJson(Map<String, dynamic> json) =>
      _$InstitutionDtoFromJson(json);
}
