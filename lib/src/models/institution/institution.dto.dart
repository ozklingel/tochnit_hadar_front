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
      name: 'racaz_id',
    )
    String rakazId,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'racaz_first_name',
    )
    String rakazFirstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'racaz_last_name',
    )
    String rakazLastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact_phone',
    )
    String rakazPhoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'admin_name',
    )
    String adminName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'admin_phone',
    )
    String adminPhoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'roshYeshiva_name',
    )
    String roshMehinaName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'roshYeshiva_phone',
    )
    String roshMehinaPhoneNumber,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'apprenticeList',
    )
    List<String> apprentices,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'melave_List',
    )
    List<String> melavim,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    double score,
    @Default(AddressDto())
    @JsonKey(
      name: 'address',
    )
    AddressDto address,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String shluha,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'logo_path',
    )
    String logo,
  }) = _InstitutionDto;

  factory InstitutionDto.fromJson(Map<String, dynamic> json) =>
      _$InstitutionDtoFromJson(json);
}

extension InstitutionX on InstitutionDto {
  bool get isEmpty => id.isEmpty;
}
