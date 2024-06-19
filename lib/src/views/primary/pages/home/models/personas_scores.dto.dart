import 'package:freezed_annotation/freezed_annotation.dart';

part 'personas_scores.dto.f.dart';
part 'personas_scores.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class PersonasScoresDto with _$PersonasScoresDto {
  const factory PersonasScoresDto({
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'score_EshcolCoordProfile_list',
    )
    List<RakazScoreDto> rakazEshkolList,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'score_MosadCoordProfile_list',
    )
    List<RakazScoreDto> rakazMosadList,
    @Default([])
    @JsonKey(
      defaultValue: [],
      name: 'score_melaveProfile_list',
    )
    List<MelaveScoreDto> melaveList,
  }) = _PersonasScoresDto;

  factory PersonasScoresDto.fromJson(Map<String, dynamic> json) =>
      _$PersonasScoresDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class RakazScoreDto with _$RakazScoreDto {
  const factory RakazScoreDto({
    @Default('')
    @JsonKey(
      fromJson: _extractId,
    )
    String id,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    double score,
  }) = _RakazScoreDto;

  factory RakazScoreDto.fromJson(Map<String, dynamic> json) =>
      _$RakazScoreDtoFromJson(json);
}

// this shouldn't exist since it's the same as rakaz score
// but again i'm tired of the backa and forth
@JsonSerializable()
@Freezed(fromJson: false)
class MelaveScoreDto with _$MelaveScoreDto {
  const factory MelaveScoreDto({
    @Default('')
    @JsonKey(
      name: 'melaveId',
      fromJson: _extractId,
    )
    String id,
    @Default(0)
    @JsonKey(
      name: 'melave_score1',
      defaultValue: 0,
    )
    double score,
  }) = _MelaveScoreDto;

  factory MelaveScoreDto.fromJson(Map<String, dynamic> json) =>
      _$MelaveScoreDtoFromJson(json);
}

String _extractId(dynamic val) {
  return val.toString();
}
