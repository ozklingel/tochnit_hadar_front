import 'package:freezed_annotation/freezed_annotation.dart';

part 'institution_pdf_export.dto.f.dart';
part 'institution_pdf_export.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class InstitutionExportPdfDto with _$InstitutionExportPdfDto {
  const factory InstitutionExportPdfDto({
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'Picud_dict',
    )
    List<Map<String, int>> pikud,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'call_gap_avg',
    )
    double callGapAvg,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'forgoten_Apprentice_count',
    )
    int forgotenApprenticeCount,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'good_Melave_ids_matzbar',
    )
    int goodMelaveIdsMatzbar,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'group_meeting_gap_avg',
    )
    double groupMeetingGapAvg,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'mahzor_dict',
    )
    List<Map<String, int>> mahzor,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'matzbar_dict',
    )
    List<Map<String, int>> matzbar,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'mitztainim',
    )
    List<int> mitztainim,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'paying_dict',
    )
    List<Map<String, int>> paying,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'personal_meet_gap_avg',
    )
    double personalMeetGapAvg,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'sugSherut_dict',
    )
    List<Map<String, int>> sherut,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'visitDoForBogrim_list',
    )
    List<dynamic> visitDoForBogrimList,
  }) = _InstitutionExportPdfDto;

  factory InstitutionExportPdfDto.fromJson(Map<String, dynamic> json) =>
      _$InstitutionExportPdfDtoFromJson(json);
}
