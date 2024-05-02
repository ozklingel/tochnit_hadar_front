import 'package:freezed_annotation/freezed_annotation.dart';

part 'melave_chart.dto.f.dart';
part 'melave_chart.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class MelaveChartDto with _$MelaveChartDto {
  const factory MelaveChartDto({
    @Default(0)
    @JsonKey(
      name: 'call_gap_avg',
      defaultValue: 0,
    )
    int callGapAvg,
    @Default(0)
    @JsonKey(
      name: 'cenes_2year',
      defaultValue: 0,
    )
    int kenesTwoYear,
    @Default(0)
    @JsonKey(
      name: 'cenes_percent',
      defaultValue: 0,
    )
    int kenesPercent,
    @Default(0)
    @JsonKey(
      name: 'forgotenApprenticeCount',
      defaultValue: 0,
    )
    int forgottenApprenticeLength,
    @Default([])
    @JsonKey(
      name: 'forgotenApprentice_full_details',
      defaultValue: [],
    )
    List<String> forgottenApprentices,
    @Default([])
    @JsonKey(
      name: 'forgotenApprentice_rivonly',
      defaultValue: [],
    )
    List<List<int>> forgotenApprenticeRivonly,
    @Default(0)
    @JsonKey(
      name: 'meet_gap_avg',
      defaultValue: 0,
    )
    int meetGapAvg,
    @Default(0)
    @JsonKey(
      name: 'melave_score',
      defaultValue: 0,
    )
    double melaveScore,
    @Default(0)
    @JsonKey(
      name: 'new_visitmeeting_Army',
      defaultValue: 0,
    )
    int newVisitMeetingArmy,
    @Default(0)
    @JsonKey(
      name: 'newvisit_cenes',
      defaultValue: 0,
    )
    int newVisitKenes,
    @Default(0)
    @JsonKey(
      name: 'numOfApprentice',
      defaultValue: 0,
    )
    int numOfApprentices,
    @Default(0)
    @JsonKey(
      name: 'numOfQuarter_passed',
      defaultValue: 0,
    )
    int numOfQuarterPassed,
    @Default(0)
    @JsonKey(
      name: 'sadna_done',
      defaultValue: 0,
    )
    int sadnaDone,
    @Default(0)
    @JsonKey(
      name: 'sadna_percent',
      defaultValue: 0,
    )
    double sadnaPercent,
    @Default(0)
    @JsonKey(
      name: 'sadna_todo',
      defaultValue: 0,
    )
    int sadnaTodo,
    @Default([])
    @JsonKey(
      name: 'visitCall_monthlyGap_avg',
      defaultValue: [],
    )
    List<List<int>> visitCallMonthlyGapAvg,
    @Default([])
    @JsonKey(
      name: 'visitCenes_4_yearly_presence',
      defaultValue: [],
    )
    List<List<int>> visitFourYearlyPresence,
    @Default(0)
    @JsonKey(
      name: 'visitHorim',
      defaultValue: 0,
    )
    int visitHorim,
    @Default([])
    @JsonKey(
      name: 'visitHorim_4_yearly',
      defaultValue: [],
    )
    List<List<int>> visitFourYearly,
    @Default([])
    @JsonKey(
      name: 'visitMeeting_monthlyGap_avg',
      defaultValue: [],
    )
    List<List<int>> visitMeetingMonthlyGapAvg,
    @Default(0)
    @JsonKey(
      name: 'visitcalls',
      defaultValue: 0,
    )
    int visitCalls,
    @Default(0)
    @JsonKey(
      name: 'visitmeetings',
      defaultValue: 0,
    )
    int visitMeetings,
    @Default([])
    @JsonKey(
      name: 'visitsadna_presence',
      defaultValue: [],
    )
    List<List<int>> visitSadnaPresence,
  }) = _MelaveChartDto;

  factory MelaveChartDto.fromJson(Map<String, dynamic> json) =>
      _$MelaveChartDtoFromJson(json);
}
