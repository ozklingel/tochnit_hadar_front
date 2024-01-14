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
    @Default([]) @JsonKey(name: 'melave_score') List<List<double>> melaveScore,
    @Default([])
    @JsonKey(name: 'Mosad_Cooordinator_score')
    List<List<double>> rakazimScore,
    @Default([])
    @JsonKey(name: 'eshcol_Cooordinator_score')
    List<List<double>> eshkolScore,
    @Default(0) double orangevisitcalls,
    @Default(0) double orangevisitmeetings,
    @Default(0) double redvisitcalls,
    @Default(0) double redvisitmeetings,
    @Default(0) double totalApprentices,
  }) = _AhraiHomeDto;

  factory AhraiHomeDto.fromJson(Map<String, dynamic> json) =>
      _$AhraiHomeDtoFromJson(json);
}
