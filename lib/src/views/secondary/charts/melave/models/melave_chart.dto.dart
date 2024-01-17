import 'package:freezed_annotation/freezed_annotation.dart';

part 'melave_chart.dto.f.dart';
part 'melave_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MelaveChartDto with _$MelaveChartDto {
  const factory MelaveChartDto({
    @Default(0) @JsonKey(name: 'NovisitHorim') double noVisitHorim,
    @Default(0) @JsonKey(name: 'OldvisitCenes') double oldVisitCenes,
    @Default(0) @JsonKey(name: 'OldvisitSadna') double oldVisitSadna,
    @Default(0)
    @JsonKey(name: 'Oldvisitmeeting_Army')
    double oldVisitMeetingArmy,
    @Default(0) @JsonKey(name: 'Oldvisitmeetings') double oldVisitMeeting,
    @Default(0)
    @JsonKey(name: 'forgotenApprenticeCount')
    double forgottenApprenticeCount,
    @Default([])
    @JsonKey(name: 'forgotenApprentice_full_details')
    List<dynamic> forgottenApprenticeFullDetails,
    @Default(0) @JsonKey(name: 'melave') double progressBarScore,
    @Default(0) @JsonKey(name: 'numOfApprentice') double apprenticesCount,
    @Default(0) @JsonKey(name: 'oldvisitcalls') double oldVisitCalls,
  }) = _MelaveChartDto;

  factory MelaveChartDto.fromJson(Map<String, dynamic> json) =>
      _$MelaveChartDtoFromJson(json);
}
