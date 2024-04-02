import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';

part 'personas_screen.dto.f.dart';
part 'personas_screen.dto.g.dart';

@JsonSerializable()
@Freezed(
  fromJson: false,
  // map: FreezedMapOptions(
  //   map: true,
  //   mapOrNull: true,
  //   maybeMap: true,
  // ),
)
class PersonasScreenDto with _$PersonasScreenDto {
  const factory PersonasScreenDto({
    @Default([]) List<PersonaDto> users,
    @Default(false) bool isMapOpen,
  }) = _PersonasScreenDto;

  // ignore: unused_element
  factory PersonasScreenDto.fromJson(Map<String, dynamic> json) =>
      _$PersonasScreenDtoFromJson(json);
}
