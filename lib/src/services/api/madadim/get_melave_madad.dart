import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/models/melave_chart.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_melave_madad.g.dart';

@Riverpod(
  dependencies: [
    // FlagsService,
    DioService,
  ],
)
class GetMelaveMadad extends _$GetMelaveMadad {
  @override
  FutureOr<MelaveChartDto> build() async {
    // final flags = ref.watch(flagsServiceProvider);

    // if (flags.isMock) {
    //   return flags.;
    // }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getForgotenApprentices);

    final parsed = MelaveChartDto.fromJson(request.data);

    ref.keepAlive();

    return parsed;
  }
}
