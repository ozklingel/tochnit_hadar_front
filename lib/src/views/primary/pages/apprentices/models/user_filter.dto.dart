import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_filter.dto.f.dart';
part 'user_filter.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class UserFilterDto with _$UserFilterDto {
  const factory UserFilterDto({
    @Default([]) List<String> roles,
    @Default([]) List<String> years,
    @Default([]) List<String> institutions,
    @Default([]) List<String> periods,
    @Default([]) List<String> eshkols,
    @Default([]) List<String> statuses,
    @Default([]) List<String> bases,
    @Default([]) List<String> hativot,
    @Default('') String region,
    @Default('') String city,
  }) = _UserFilterDto;

  // ignore: unused_element
  factory UserFilterDto.fromJson(Map<String, dynamic> json) =>
      _$UserFilterDtoFromJson(json);
}
