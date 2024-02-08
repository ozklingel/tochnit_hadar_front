import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/models/rakaz_mosad_chart.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rakaz_mosad_chart_controller.g.dart';

@Riverpod(
  dependencies: [
    Storage,
    DioService,
  ],
)
class RakazMosadChartController extends _$RakazMosadChartController {
  @override
  Future<RakazMosadChartDto> build() async {
    final phone = ref.watch(storageProvider.notifier).getUserPhone();

    final result = await ref.watch(dioServiceProvider).get(
      Consts.chartsMosad,
      queryParameters: {'mosadCoordinator': phone},
    );

    final parsed = RakazMosadChartDto.fromJson(result.data);

    return parsed;
  }
}
