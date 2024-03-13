import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';

part 'filter.dto.f.dart';
part 'filter.dto.g.dart';

@JsonSerializable()
@Freezed(
  fromJson: false,
  // map: FreezedMapOptions(
  //   map: true,
  //   mapOrNull: true,
  //   maybeMap: true,
  // ),
)
class FilterDto with _$FilterDto {
  const factory FilterDto({
    @Default([]) List<String> roles,
    @Default([]) List<String> years,
    @Default([]) List<String> institutions,
    @Default([]) List<String> periods,
    @Default([]) List<String> eshkols,
    @Default([]) List<String> statuses,
    @Default([]) List<String> bases,
    @Default([]) List<String> hativot,
    @Default([]) List<String> regions,
    @Default([]) List<String> cities,
    @Default([]) List<String> ramim,
    @Default([]) List<ReportEventType> reportEventTypes,
  }) = _UserFilterDto;

  // ignore: unused_element
  factory FilterDto.fromJson(Map<String, dynamic> json) =>
      _$FilterDtoFromJson(json);
}

extension FilterDtoX on FilterDto {
  bool get isEmpty {
    return roles.isEmpty &&
        years.isEmpty &&
        institutions.isEmpty &&
        periods.isEmpty &&
        eshkols.isEmpty &&
        statuses.isEmpty &&
        bases.isEmpty &&
        hativot.isEmpty &&
        regions.isEmpty &&
        cities.isEmpty &&
        ramim.isEmpty &&
        reportEventTypes.isEmpty;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }

  int get length {
    return roles.length +
        years.length +
        institutions.length +
        periods.length +
        eshkols.length +
        statuses.length +
        bases.length +
        hativot.length +
        regions.length +
        cities.length +
        ramim.length +
        reportEventTypes.length;
  }
}
