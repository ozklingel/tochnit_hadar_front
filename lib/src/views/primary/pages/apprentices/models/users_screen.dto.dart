import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

part 'users_screen.dto.f.dart';
part 'users_screen.dto.g.dart';

@JsonSerializable()
@Freezed(
  fromJson: false,
  // map: FreezedMapOptions(
  //   map: true,
  //   mapOrNull: true,
  //   maybeMap: true,
  // ),
)
class UsersScreenDto with _$UsersScreenDto {
  const factory UsersScreenDto({
    @Default([]) List<ApprenticeDto> users,
    @Default(false) bool isMapOpen,
  }) = _UsersScreenDto;

  // ignore: unused_element
  factory UsersScreenDto.fromJson(Map<String, dynamic> json) =>
      _$UsersScreenDtoFromJson(json);
}
