import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'ahrai_home.dto.f.dart';
part 'ahrai_home.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AhraiHomeDto with _$AhraiHomeDto {
  const factory AhraiHomeDto({
    @Default([])
    @JsonKey(
      name: 'Mosad_Cooordinator_score',
      fromJson: _extractScore,
    )
    List<(double, double)> rakazimScore,
    @Default([])
    @JsonKey(
      name: 'eshcol_Cooordinator_score',
      fromJson: _extractScore,
    )
    List<(double, double)> eshkolScore,
    @Default(0) double greenvisitcalls,
    @Default(0) double greenvisitmeetings,
    @Default([])
    @JsonKey(
      name: 'melave_score',
      fromJson: _extractScore,
    )
    List<(double, double)> melaveScore,
    @Default(0) double orangevisitcalls,
    @Default(0) double orangevisitmeetings,
    @Default(0) double redvisitcalls,
    @Default(0) double redvisitmeetings,
    @Default([])
    @JsonKey(name: 'score_Mosad_Eshcol_CoordProfile_list')
    List<Map<String, dynamic>> scoreMosadEshcolCoordProfileList,
    @Default([])
    @JsonKey(name: 'score_melaveProfile_list')
    List<Map<String, dynamic>> scoreMelaveProfileList,
    @Default(0) int totalApprentices,
  }) = _AhraiHomeDto;

  factory AhraiHomeDto.fromJson(Map<String, dynamic> json) =>
      _$AhraiHomeDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class CoordProfileDto with _$CoordProfileDto {
  const factory CoordProfileDto({
    @Default('')
    @JsonKey(
      name: 'id',
      fromJson: _extractId,
    )
    String id,
    @Default(0)
    @JsonKey(
      name: 'score',
      defaultValue: 0,
    )
    double score,
  }) = _CoordProfileDto;

  factory CoordProfileDto.fromJson(Map<String, dynamic> json) =>
      _$CoordProfileDtoFromJson(json);
}

@JsonSerializable()
@Freezed(fromJson: false)
class MelaveProfileDto with _$MelaveProfileDto {
  const factory MelaveProfileDto({
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
  }) = _MelaveProfileDto;

  factory MelaveProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MelaveProfileDtoFromJson(json);
}

String _extractId(String? data) {
  return (data ?? '').toString();
}

List<(double, double)> _extractScore(List<dynamic>? data) {
  if (data == null || data.isEmpty || data.first!.isEmpty || data.length == 1) {
    Sentry.captureMessage(
      'bad backend _extractScore data type',
      params: [
        data,
      ],
    );

    return [
      (0, 0),
      (0, 0),
    ];
  }

  return data
      .map<(num, num)>((e) {
        if ((e as List<dynamic>).length < 2) {
          Sentry.captureMessage(
            'bad backend _extractScore data length',
            params: [data],
          );

          return (0, 0);
        }

        return (e[0], e[1]);
      })
      .map<(double, double)>((e) => (e.$1.toDouble(), e.$2.toDouble()))
      .toList();
}
