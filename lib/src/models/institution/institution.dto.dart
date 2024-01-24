import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/address/address.dto.dart';

part 'institution.dto.f.dart';
part 'institution.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class InstitutionDto with _$InstitutionDto {
  const factory InstitutionDto({
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
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String rakaz,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String rakazPhoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String shluha,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String phoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String roshMehinaName,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String roshMehinaPhoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String menahelAdministrativiName,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String menahelAdministrativiPhoneNumber,
    @Default([])
    @JsonKey(
      defaultValue: [],
    )
    List<String> melavim,
    @Default([])
    @JsonKey(
      defaultValue: [],
    )
    List<String> hanihim,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    double score,
    @Default(AddressDto()) AddressDto address,
  }) = _InstitutionDto;

  factory InstitutionDto.fromJson(Map<String, dynamic> json) =>
      _$InstitutionDtoFromJson(json);
}
