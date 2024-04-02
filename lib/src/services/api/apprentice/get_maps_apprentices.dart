import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_maps_apprentices.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetMapsApprentices extends _$GetMapsApprentices {
  @override
  Future<List<PersonaDto>> build() async {
    final result =
        await ref.watch(dioServiceProvider).get(Consts.getMapsApprentices);

    final parsed = result.data as List<dynamic>;

    final processed = parsed.map((e) => PersonaDto.fromJson(e)).toList();

    ref.keepAlive();

    return processed;
  }
}
