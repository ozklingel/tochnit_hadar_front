import 'package:freezed_annotation/freezed_annotation.dart';

part 'melave_chart.dto.f.dart';
part 'melave_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MelaveChartDto with _$MelaveChartDto {
  const factory MelaveChartDto({
    @Default(-1)
    @JsonKey(name: 'No_visitHorim')
    int noVisitHorim, // No_visitHorim
    @Default(-1) @JsonKey(name: 'cenes_score') int kenesScore, // cenes_score
    @Default(-1) @JsonKey(name: 'sadna_score') int sadnaScore, // sadna_score
    @Default(-1)
    @JsonKey(name: 'new_visitmeeting_Army')
    int newVisitMeetingArmy, // new_visitmeeting_Army
    @Default(-1)
    @JsonKey(name: 'Oldvisitmeetings')
    int oldVisitMeeting, // Oldvisitmeetings
    @Default(-1)
    @JsonKey(name: 'forgotenApprenticeCount')
    int forgottenApprenticeCount, // forgotenApprenticeCount
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<dynamic>
        forgottenApprenticeFullDetails, // forgotenApprentice_full_details
    @Default(-1) @JsonKey(name: 'melave_score') int melaveScore, // melave_score
    @Default(-1)
    @JsonKey(name: 'numOfApprentice')
    int apprenticesCount, // numOfApprentice
    @Default(-1)
    @JsonKey(name: 'oldvisitcalls')
    int oldVisitCalls, // oldvisitcalls
  }) = _MelaveChartDto;

  factory MelaveChartDto.fromJson(Map<String, dynamic> json) =>
      _$MelaveChartDtoFromJson(json);
}
