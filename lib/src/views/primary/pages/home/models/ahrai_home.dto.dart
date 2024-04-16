import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'ahrai_home.dto.f.dart';
part 'ahrai_home.dto.g.dart';

@JsonSerializable()
@Freezed(fromJson: false)
class AhraiHomeDto with _$AhraiHomeDto {
  const factory AhraiHomeDto({
    @Default(0) double forgotenApprenticCount,
    @Default(0) double greenvisitcalls,
    @Default(0) double greenvisitmeetings,
    @Default([])
    @JsonKey(
      name: 'melave_score',
      fromJson: _extractScore,
    )
    List<(double, double)> melaveScore,
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
    @Default(0) double orangevisitcalls,
    @Default(0) double orangevisitmeetings,
    @Default(0) double redvisitcalls,
    @Default(0) double redvisitmeetings,
    @Default(0) double totalApprentices,
  }) = _AhraiHomeDto;

  factory AhraiHomeDto.fromJson(Map<String, dynamic> json) =>
      _$AhraiHomeDtoFromJson(json);
}

List<(double, double)> _extractScore(List<dynamic>? data) {
  if (data == null || data.isEmpty || data.first!.isEmpty || data.length == 1) {
    Sentry.captureException('bad backend _extractScore data');

    return [
      (0, 0),
      (0, 0),
    ];
  }

  return data
      .map<(num, num)>((e) {
        if ((e as List<dynamic>).length < 2) {
          Sentry.captureException('bad backend _extractScore data');

          return (0, 0);
        }

        return (e[0], e[1]);
      })
      .map<(double, double)>((e) => (e.$1.toDouble(), e.$2.toDouble()))
      .toList();
}
