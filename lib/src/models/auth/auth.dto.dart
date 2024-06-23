import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/utils/convert/extract_from_json.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth.dto.f.dart';
part 'auth.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AuthDto with _$AuthDto {
  const factory AuthDto({
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String id,
    @Default('')
    @JsonKey(
      fromJson: extractAvatarFromJson,
      name: 'photo_path',
    )
    String avatar,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'name',
    )
    String firstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'last_name',
    )
    String lastName,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String phone,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String email,
    @Default(UserRole.unknown)
    @JsonKey(
      fromJson: _extractUserRole,
      name: 'role_ids',
    )
    UserRole role,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'institution_id',
    )
    String institution,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'eshcol',
    )
    String cluster,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String city,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'cluster_id',
    )
    String region,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'birthday',
    )
    String dateOfBirth,
    @Default([])
    @JsonKey(
      fromJson: _parseApprentices,
    )
    List<String> apprentices,
  }) = _AuthDto;

  factory AuthDto.fromJson(Map<String, dynamic> json) =>
      _$AuthDtoFromJson(json);
}

List<String> _parseApprentices(List<dynamic> apprentices) {
  final ids = apprentices
      .cast<Map<String, dynamic>>()
      .map((e) => e['id'].toString())
      .toList();

  return ids;
}

UserRole _extractUserRole(dynamic role) {
  if (role == null || role.isEmpty || role is! List) {
    Logger().w('empty user role');
    Sentry.captureException(Exception('failed to extract role from string'));
    return UserRole.unknown;
  }

  final roleIndex = int.tryParse(role.first.toString());

  if (roleIndex == null) {
    Logger().w('bad user role index');
    Sentry.captureException(Exception('failed to extract role from index'));
    return UserRole.unknown;
  }

  final result = UserRole.values.firstWhere(
    (element) => element.val == roleIndex,
  );

  return result;
}

extension UserDtoX on AuthDto? {
  String get fullName => '${this?.firstName ?? ''} ${this?.lastName}';
}
