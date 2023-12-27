import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'user.dto.f.dart';
part 'user.dto.g.dart';

enum UserRole {
  melave,
  ahraiTohnit,
  rakazMosad,
  rakazEshkol,
  other;

  String get name {
    switch (this) {
      case UserRole.melave:
        return 'מלווה';
      case UserRole.ahraiTohnit:
        return 'אחראי תכנית';
      case UserRole.rakazMosad:
        return 'רכז מוסד';
      case UserRole.rakazEshkol:
        return 'רכז אשכול';
      default:
        return 'USER.ROLE.ERROR';
    }
  }
}

@JsonSerializable()
@Freezed(fromJson: false)
class UserDto with _$UserDto {
  const factory UserDto({
    @Default('') String id,
    @Default('') @JsonKey(defaultValue: '') String avatar,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String email,
    @Default(UserRole.other) UserRole role,
    @Default('') String institution,
    @Default('') String cluster,
    @Default('') String city,
    @Default('') String region,
    @Default(0) int dateOfBirthInMsSinceEpoch,
    @Default([]) List<ApprenticeDto> apprentices,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoX on UserDto? {
  String get fullName => '${this?.firstName ?? ''} ${this?.lastName}';
}
