import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_apprentice_and_melave.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetApprenticesAndMelavim extends _$GetApprenticesAndMelavim {
  @override
  FutureOr<List<ApprenticeDto>> build({required String id}) async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.apprentices;
    }

    final request = await ref.watch(dioServiceProvider).get(
      Consts.getAllInstitutionApprenticesAndMelavim,
      queryParameters: {
        'institution_id': id,
      },
    );

    final result = (request.data as List<dynamic>)
        .map(
          (e) => ApprenticeDto.fromJson(e),
        )
        .toList();

    return result;
  }
}
