import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:logger/logger.dart';

part 'user.dto.f.dart';
part 'user.dto.g.dart';

enum UserRole {
  melave,
  rakazMosad,
  rakazEshkol,
  ahraiTohnit,
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
    @Default(UserRole.other) @JsonKey(fromJson: _extractUserRole) UserRole role,
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

UserRole _extractUserRole(String? role) {
  if (role == null) {
    Logger().w('empty user role');
  }

  final result = UserRole.values.byName(role!);

  if (result == UserRole.other) {
    Logger().w('failed to parse user role');
  }

  return result;
}

extension UserDtoX on UserDto? {
  String get fullName => '${this?.firstName ?? ''} ${this?.lastName}';
}
