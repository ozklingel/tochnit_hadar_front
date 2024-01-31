import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_filter.dto.f.dart';
part 'user_filter.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class UserFilterDto with _$UserFilterDto {
  const factory UserFilterDto({
    @Default('') String role,
    @Default('') String year,
    @Default('') String institution,
    @Default('') String period,
    @Default('') String eshkol,
    @Default('') String status,
    @Default('') String base,
    @Default('') String hativa,
    @Default('') String region,
    @Default('') String city,
  }) = _UserFilterDto;

  // ignore: unused_element
  factory UserFilterDto.fromJson(Map<String, dynamic> json) =>
      _$UserFilterDtoFromJson(json);
}
