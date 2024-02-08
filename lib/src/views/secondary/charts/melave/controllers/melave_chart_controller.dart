import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/models/melave_chart.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'melave_chart_controller.g.dart';

@Riverpod(
  dependencies: [
    Storage,
    DioService,
  ],
)
class MelaveChartController extends _$MelaveChartController {
  @override
  Future<MelaveChartDto> build() async {
    final phone = ref.watch(storageProvider.notifier).getUserPhone();

    final result = await ref.watch(dioServiceProvider).get(
      Consts.chartsMelave,
      queryParameters: {'melaveId': phone},
    );

    final parsed = MelaveChartDto.fromJson(result.data);

    return parsed;
  }
}
