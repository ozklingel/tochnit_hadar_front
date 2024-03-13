import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/models/filter.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_reports.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class FilterReports extends _$FilterReports {
  @override
  FutureOr<List<String>> build(FilterDto filter) async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.reports.map((e) => e.id).toList();
    }

    final request = await ref.watch(dioServiceProvider).get(
      Consts.filterReports,
      queryParameters: {
        'roles': filter.roles,
        'hativa': filter.hativot,
        'years': filter.years,
        'preiods': filter.periods,
        'statuses': filter.statuses,
        'bases': filter.bases,
        'region': filter.regions,
        'eshcols': filter.eshkols,
        'city': filter.cities,
      },
    );

    final parsed =
        (request.data as List<dynamic>).map<String>((e) => e).toList();

    return parsed;
  }
}
