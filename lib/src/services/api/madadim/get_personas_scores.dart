import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/personas_scores.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_personas_scores.g.dart';

@Riverpod(
  dependencies: [
    // FlagsService,
    DioService,
  ],
)
class GetPersonasScores extends _$GetPersonasScores {
  @override
  FutureOr<PersonasScoresDto> build() async {
    // final flags = ref.watch(flagsServiceProvider);

    // if (flags.isMock) {
    //   return flags.;
    // }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.chartsPersonasScore);

    final parsed = PersonasScoresDto.fromJson(request.data);

    ref.keepAlive();

    return parsed;
  }
}
