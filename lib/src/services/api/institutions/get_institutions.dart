import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_institutions.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetInstitutions extends _$GetInstitutions {
  @override
  FutureOr<List<InstitutionDto>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.institutions;
    }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllInstitutions);

    final result = (request.data as List<dynamic>)
        .map(
          (e) => InstitutionDto.fromJson(e),
        )
        .toList();

    return result;
  }
}
