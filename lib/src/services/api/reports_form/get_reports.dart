import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_reports.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetReports extends _$GetReports {
  @override
  FutureOr<List<ReportDto>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.reports;
    }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllReports);

    final reports = (request.data as List<dynamic>).map(
      (e) {
        final item = ReportDto.fromJson(e);
        // Logger().d(item);
        return item;
      },
    ).toList();

    return reports;
  }
}
