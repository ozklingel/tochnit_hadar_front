import 'package:freezed_annotation/freezed_annotation.dart';

part 'ahrai_home.dto.f.dart';
part 'ahrai_home.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AhraiHomeDto with _$AhraiHomeDto {
  const factory AhraiHomeDto({
    @Default(0) double forgotenApprenticCount,
    @Default(0) double greenvisitcalls,
    @Default(0) double greenvisitmeetings,
    @Default(0) @JsonKey(name: 'melave_score') double melaveScore,
    @Default(0) double orangevisitcalls,
    @Default(0) double orangevisitmeetings,
    @Default(0) double redvisitcalls,
    @Default(0) double redvisitmeetings,
    @Default(0) double totalApprentices,
    @Default('') @JsonKey(name: 'user_lastname') String userLastname,
    @Default('') @JsonKey(name: 'user_name') String userName,
  }) = _AhraiHomeDto;

  factory AhraiHomeDto.fromJson(Map<String, dynamic> json) =>
      _$AhraiHomeDtoFromJson(json);
}
