import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/secondary/charts/rakaz_eshkol/models/rakaz_eshkol_chart.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rakaz_eshkol_chart_controller.g.dart';

@Riverpod(
  dependencies: [
    Storage,
    dio,
  ],
)
class RakazEshkolChartController extends _$RakazEshkolChartController {
  @override
  Future<RakazEshkolChartDto> build() async {
    final phone = ref.watch(storageProvider.notifier).getUserPhone();

    final result = await ref.watch(dioProvider).get(
      'madadim/eshcolCoordinator',
      queryParameters: {'eshcolCoordinator': phone},
    );

    final parsed = RakazEshkolChartDto.fromJson(result.data);

    return parsed;
  }
}
