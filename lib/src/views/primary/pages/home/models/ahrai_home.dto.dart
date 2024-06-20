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
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int forgotenApprenticCount,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'greenvisitcalls',
    )
    double greenVisitCalls,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'greenvisitmeetings',
    )
    double greenVisitMeetings,
    @Default([])
    @JsonKey(
      name: 'melave_score',
      fromJson: _extractScore,
    )
    List<(double, double)> melaveScore,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'orangevisitcalls',
    )
    double orangeVisitCalls,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'orangevisitmeetings',
    )
    double orangeVisitMeetings,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'redvisitcalls',
    )
    double redVisitCalls,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
      name: 'redvisitmeetings',
    )
    double redVisitMeetings,
    @Default(0)
    @JsonKey(
      defaultValue: 0,
    )
    int totalApprentices,
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
  if (data == null || data.length != 2) {
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

  final firstList = List<num>.from(data[0]);
  final secondList = List<num>.from(data[1]);

  final result = <(double, double)>[];

  for (int i = 0; i < firstList.length; i++) {
    result.add(
      (
        firstList[i].toDouble(),
        secondList[i].toDouble(),
      ),
    );
  }

  return result;
}
