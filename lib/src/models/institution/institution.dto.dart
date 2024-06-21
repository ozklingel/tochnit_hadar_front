import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/utils/convert/extract_from_json.dart';
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
      name: 'racaz_firstName',
    )
    String rakazFirstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'racaz_lastName',
    )
    String rakazLastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'contact_phone',
    )
    String rakazContactPhoneNumber,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'phone',
    )
    String phoneNumber,
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
    String roshYeshivaPhoneNumber,
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
      name: 'logo_path',
      fromJson: extractAvatarFromJson,
    )
    String logo,
    @Default('')
    @JsonKey(
      name: 'eshcol',
    )
    String eshkol,
  }) = _InstitutionDto;

  factory InstitutionDto.fromJson(Map<String, dynamic> json) =>
      _$InstitutionDtoFromJson(json);
}

extension InstitutionX on InstitutionDto {
  bool get isEmpty => id.isEmpty;
}
