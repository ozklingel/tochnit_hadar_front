import 'package:freezed_annotation/freezed_annotation.dart';

part 'rakaz_eshkol_chart.dto.f.dart';
part 'rakaz_eshkol_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class RakazEshkolChartDto with _$RakazEshkolChartDto {
  const factory RakazEshkolChartDto({
    @Default(-1)
    @JsonKey(name: 'Apprentice_forgoten_count')
    int apprenticeForgottenCount, // Apprentice_forgoten_count
    @Default(-1)
    @JsonKey(name: 'all_EshcolApprentices_count')
    int allEshcolApprenticesCount, // all_EshcolApprentices_count
    @Default(-1)
    @JsonKey(name: 'all_MosadCoordinator_count')
    int allMosadCoordinatorCount, // all_MosadCoordinator_count
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<dynamic>
        forgottenApprenticeFullDetails, // forgotenApprentice_full_details
    @Default(-1)
    @JsonKey(name: 'eshcolCoordinator_score')
    int eshkolCoordinatorScore, // eshcolCoordinator_score
    @Default(-1)
    @JsonKey(name: 'good__mosad_racaz_meeting')
    int goodMosadRacazMeeting, // good__mosad_racaz_meeting
    @Default(-1)
    @JsonKey(name: 'newvisit_yeshiva_Tohnit')
    int newVisitYeshivaTohnit, // newvisit_yeshiva_Tohnit
  }) = _RakazEshkolChartDto;

  factory RakazEshkolChartDto.fromJson(Map<String, dynamic> json) =>
      _$RakazEshkolChartDtoFromJson(json);
}
