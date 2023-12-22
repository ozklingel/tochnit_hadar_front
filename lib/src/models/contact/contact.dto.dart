import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.dto.f.dart';
part 'contact.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ContactDto with _$ContactDto {
  const factory ContactDto({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String relationship,
  }) = _ContactDto;

  // ignore: unused_element
  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);
}

extension ContactDtoX on ContactDto {
  String get fullName => '$firstName $lastName';
}
