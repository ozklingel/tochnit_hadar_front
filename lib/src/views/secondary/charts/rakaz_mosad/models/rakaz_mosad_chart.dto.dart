import 'package:freezed_annotation/freezed_annotation.dart';

part 'rakaz_mosad_chart.dto.f.dart';
part 'rakaz_mosad_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class RakazMosadChartDto with _$RakazMosadChartDto {
  const factory RakazMosadChartDto({
    @Default(0)
    @JsonKey(name: 'Apprentice_forgoten_count')
    double apprenticeForgottenCount,
    @Default(0) @JsonKey(name: 'all_Melave_mosad') double allMelaveMosad,
    @Default(0)
    @JsonKey(name: 'all_apprenties_mosad')
    double allApprenticesMosad,
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<List<dynamic>> forgottenApprenticesFullDetails,
    @Default(0)
    @JsonKey(name: 'good_Melave_ids_matzbar')
    double goodMelaveIdsMatzbar,
    @Default(0)
    @JsonKey(name: 'good_Melave_ids_sadna')
    double goodMelaveIdsSadna,
    @Default(0)
    @JsonKey(name: 'good_MelavimMeeting_count')
    double goodMelaveMeetingCount,
    @Default(0)
    @JsonKey(name: 'good_apprentice_mosad_groupMeet')
    double goodApprenticeMosadGroupMeet,
    @Default(0)
    @JsonKey(name: 'good_apprenties_mosad_call')
    double goodApprenticeMosadCall,
    @Default(0)
    @JsonKey(name: 'good_apprenties_mosad_meet')
    double goodApprenticeMosadMeet,
    @Default(false) @JsonKey(name: 'isVisitenterMahzor') bool isVisitedMahzor,
    @Default(0) @JsonKey(name: 'mosadCoordinator_score') double progressBar,
    @Default(0) @JsonKey(name: 'new_MelavimMeeting') double newMelaveMeeting,
    @Default(0) @JsonKey(name: 'visitDoForBogrim') double visitDoForBogrim,
  }) = _RakazMosadChartDto;

  factory RakazMosadChartDto.fromJson(Map<String, dynamic> json) =>
      _$RakazMosadChartDtoFromJson(json);
}
