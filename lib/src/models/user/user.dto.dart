import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'user.dto.f.dart';
part 'user.dto.g.dart';

@JsonSerializable()
@Freezed()
class UserDto with _$UserDto {
  const factory UserDto({
    @Default('') String id,
    @Default('') String avatar,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String role,
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
