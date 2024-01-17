import 'package:freezed_annotation/freezed_annotation.dart';

part 'rakaz_eshkol_chart.dto.f.dart';
part 'rakaz_eshkol_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class RakazEshkolChartDto with _$RakazEshkolChartDto {
  const factory RakazEshkolChartDto({
    @Default(0)
    @JsonKey(name: 'Apprentice_forgoten_count')
    double apprenticeForgottenCount,
    @Default(0)
    @JsonKey(name: 'all_MosadCoordinator_count')
    double allMosadCoordinatorCount,
    @Default(0) @JsonKey(name: 'eshcolCoordinator') double progressBarScore,
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<dynamic> forgottenApprenticeFullDetails,
    @Default(0)
    @JsonKey(name: 'good_apprenties_mosad_call')
    double goodApprenticesMosadCall,
    @Default(0)
    @JsonKey(name: 'newvisit_yeshiva_Tohnit')
    double newVisitYeshivaTohnit,
  }) = _RakazEshkolChartDto;

  factory RakazEshkolChartDto.fromJson(Map<String, dynamic> json) =>
      _$RakazEshkolChartDtoFromJson(json);
}
