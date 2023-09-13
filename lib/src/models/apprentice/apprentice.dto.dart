import 'package:freezed_annotation/freezed_annotation.dart';

part 'apprentice.dto.f.dart';
part 'apprentice.dto.g.dart';

@JsonSerializable()
@Freezed()
class ApprenticeDto with _$ApprenticeDto {
  const factory ApprenticeDto({
    @Default('') String id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String avatar,
  }) = _Apprentice;

  factory ApprenticeDto.fromJson(Map<String, dynamic> json) =>
      _$ApprenticeDtoFromJson(json);
}
