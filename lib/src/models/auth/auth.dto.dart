import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth.dto.f.dart';
part 'auth.dto.g.dart';

enum UserRole {
  melave(0),

  rakazMosad(1),

  rakazEshkol(2),
  ahraiTohnit(3),

  apprentice(500),
  other(800);

  const UserRole(this.val);

  final int val;

  String get name => switch (this) {
        UserRole.melave => 'מלווה',
        UserRole.rakazMosad => 'רכז מוסד',
        UserRole.rakazEshkol => 'רכז אשכול',
        UserRole.ahraiTohnit => 'אחראי תכנית',
        _ => 'USER.ROLE.ERROR',
      };

  bool get isProgramDirector => this == UserRole.ahraiTohnit;
}

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
      defaultValue: '',
    )
    String avatar,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String firstName,
    @Default('')
    @JsonKey(
      defaultValue: '',
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
    @Default(UserRole.other)
    @JsonKey(
      fromJson: _extractUserRole,
    )
    UserRole role,
    @Default('')
    @JsonKey(
      defaultValue: '',
    )
    String institution,
    @Default('')
    @JsonKey(
      defaultValue: '',
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
    )
    String region,
    @Default('')
    @JsonKey(
      defaultValue: '',
      name: 'date_of_birth',
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
    return UserRole.other;
  }

  final roleIndex = int.tryParse(role.first.toString());

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

extension UserDtoX on AuthDto? {
  String get fullName => '${this?.firstName ?? ''} ${this?.lastName}';
}
