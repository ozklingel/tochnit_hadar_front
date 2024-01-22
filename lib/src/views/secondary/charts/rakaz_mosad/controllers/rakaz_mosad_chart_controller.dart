import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_mosad/models/rakaz_mosad_chart.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rakaz_mosad_chart_controller.g.dart';

@Riverpod(
  dependencies: [
    Storage,
    dio,
  ],
)
class RakazMosadChartController extends _$RakazMosadChartController {
  @override
  Future<RakazMosadChartDto> build() async {
    final phone = ref.watch(storageProvider.notifier).getUserPhone();

    final result = await ref.watch(dioProvider).get(
      '/madadim/mosadCoordinator',
      queryParameters: {'mosadCoordinator': phone},
    );

    final parsed = RakazMosadChartDto.fromJson(result.data);

    return parsed;
  }
}
