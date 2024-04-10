import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_settings.dto.f.dart';
part 'chart_settings.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class ChartSettingsDto with _$ChartSettingsDto {
  const factory ChartSettingsDto({
    @Default('')
    @JsonKey(name: 'callHorim_madad_date')
    @Default('')
    String callHorimMadadDate,
    @Default('')
    @JsonKey(name: 'call_madad_date') //
    String callMadadDate,
    @Default('')
    @JsonKey(name: 'cenes_report') //
    String conferenceReport,
    @Default('')
    @JsonKey(name: 'doForBogrim_madad_date')
    String doForBogrimMadadDate,
    @Default('')
    @JsonKey(name: 'eshcolMosadMeet_madad_date')
    String eshcolMosadMeetMadadDate,
    @Default('')
    @JsonKey(name: 'groupMeet_madad_date')
    String groupMeetMadadDate,
    @Default('')
    @JsonKey(name: 'matzbarmeet_madad_date')
    String matzbarMeetMadadDate,
    @Default('') @JsonKey(name: 'meet_madad_date') String meetMadadDate,
    @Default('')
    @JsonKey(name: 'professionalMeet_madad_date')
    String professionalMeetMadadDate,
    @Default('')
    @JsonKey(name: 'tochnitMeet_madad_date')
    String tochnitMeetMadadDate,
  }) = _ChartSettingsDto;

  factory ChartSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$ChartSettingsDtoFromJson(json);
}
