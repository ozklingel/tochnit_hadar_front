import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_filtered_users.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetFilteredUsers extends _$GetFilteredUsers {
  @override
  FutureOr<List<String>> build(FilterDto filter) async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.apprentices.map((e) => e.id).toList();
    }

    final request = await ref.watch(dioServiceProvider).get(
      Consts.getAllFiltered,
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

    final parsed = request.data['filtered'] as List<dynamic>;

    return parsed.map<String>((e) => e).toList();
  }
}
