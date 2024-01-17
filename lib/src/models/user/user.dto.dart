import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      // Mosad_Cooordinator
      case UserRole.rakazMosad:
        return 'רכז מוסד';
      // eshcol_Cooordinator
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
    @Default('') @JsonKey(name: 'date_of_birth') String dateOfBirth,
    @Default([]) @JsonKey(fromJson: _parseApprentices) List<String> apprentices,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

List<String> _parseApprentices(List<dynamic> apprentices) {
  final ids = apprentices
      .cast<Map<String, dynamic>>()
      .map((e) => e['id'].toString())
      .toList();

  return ids;
}

UserRole _extractUserRole(dynamic role) {
  if (role == null) {
    Logger().w('empty user role');
    Sentry.captureException(Exception('failed to extract role from string'));
    return UserRole.other;
  }

  final roleIndex = int.tryParse(role);

  if (roleIndex == null) {
    Logger().w('bad user role index');
    Sentry.captureException(Exception('failed to extract role from index'));
    return UserRole.other;
  }

  final result = UserRole.values.firstWhere(
    (element) => element.index == roleIndex,
  );

  return result;
}

extension UserDtoX on UserDto? {
  String get fullName => '${this?.firstName ?? ''} ${this?.lastName}';
}
