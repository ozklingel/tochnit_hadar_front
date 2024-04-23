import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_personas.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetPersonas extends _$GetPersonas {
  @override
  FutureOr<List<PersonaDto>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.apprentices;
    }

    final request = await ref.watch(dioServiceProvider).get(
          Consts.getAllPersonas,
          // Consts.getAllFiltered,
          // queryParameters: {
          //   'roles': filter.roles.join(','),
          // },
        );

    final result = (request.data as List<dynamic>)
        .map(
          (e) => PersonaDto.fromJson(e),
        )
        .toList();

    ref.keepAlive();

    return result;
  }
}
