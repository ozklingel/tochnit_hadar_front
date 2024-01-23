import 'package:freezed_annotation/freezed_annotation.dart';

part 'rakaz_mosad_chart.dto.f.dart';
part 'rakaz_mosad_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class RakazMosadChartDto with _$RakazMosadChartDto {
  const factory RakazMosadChartDto({
    @Default(-1)
    @JsonKey(name: 'Apprentice_forgoten_count')
    int apprenticeForgottenCount, // Apprentice_forgoten_count
    @Default(-1)
    @JsonKey(name: 'all_Melave_mosad_count')
    int allMelaveMosadCount, // all_Melave_mosad_count
    @Default(-1)
    @JsonKey(name: 'all_apprenties_mosad')
    int allApprentiesMosadCount, // all_apprenties_mosad
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<List<dynamic>>
        forgottenApprenticesFullDetails, // forgotenApprentice_full_details
    @Default(-1)
    @JsonKey(name: 'avg_presence_MelavimMeeting')
    double avgPresenceMelavimMeeting, // avg_presence_MelavimMeeting
    @Default(-1)
    @JsonKey(name: 'good_Melave_ids_matzbar')
    int goodMelaveIdsMatzbar, // good_Melave_ids_matzbar
    @Default(-1)
    @JsonKey(name: 'good_Melave_ids_sadna')
    int goodMelaveIdsSadna, // good_Melave_ids_sadna
    @Default(-1)
    @JsonKey(name: 'good_apprentice_mosad_groupMeet')
    int goodApprenticeMosadGroupMeet, // good_apprentice_mosad_groupMeet
    @Default(-1)
    @JsonKey(name: 'good_apprenties_mosad_call')
    int goodApprenticeMosadCall, // good_apprenties_mosad_call
    @Default(-1)
    @JsonKey(name: 'good_apprenties_mosad_meet')
    int goodApprenticeMosadMeet, // good_apprenties_mosad_meet
    @Default(-1)
    @JsonKey(name: 'mosadCoordinator_score')
    int mosadCoordinatorScore, // mosadCoordinator_score
    @Default(-1)
    @JsonKey(name: 'new_MelavimMeeting')
    int newMelaveMeeting, // new_MelavimMeeting
    @Default(-1)
    @JsonKey(name: 'visitDoForBogrim')
    int visitDoForBogrim, // visitDoForBogrim
    @Default(false)
    @JsonKey(name: 'isVisitenterMahzor')
    bool isVisitedMahzor, // isVisitenterMahzor
  }) = _RakazMosadChartDto;

  factory RakazMosadChartDto.fromJson(Map<String, dynamic> json) =>
      _$RakazMosadChartDtoFromJson(json);
}
