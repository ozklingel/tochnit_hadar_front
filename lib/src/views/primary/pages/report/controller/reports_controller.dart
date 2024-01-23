import 'package:collection/collection.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_controller.g.dart';

enum SortReportBy {
  fromA2Z,
  timeFromCloseToFar,
  timeFromFarToClose,
}

@Riverpod(
  dependencies: [
    dio,
  ],
)
class ReportsController extends _$ReportsController {
  @override
  FutureOr<List<ReportDto>> build() async {
    final request = await ref.watch(dioProvider).get('reports_form/getAll');

    final reports = (request.data as List<dynamic>).map(
      (e) {
        final item = ReportDto.fromJson(e);
        // Logger().d(item);
        return item;
      },
    ).toList();

    // await Future.delayed(const Duration(milliseconds: 200));

    // final reports = List.generate(
    //   44,
    //   (index) {
    //     return ReportDto(
    //       id: faker.guid.guid(),
    //       description: faker.lorem.sentence(),
    //       apprentices: List.generate(
    //         13,
    //         (index) => Consts.mockApprenticeGuids[
    //             Random().nextInt(Consts.mockApprenticeGuids.length)],
    //       ),
    //       reportEventType: ReportEventType.values[Random().nextInt(6)],
    //       attachments: List.generate(
    //         11,
    //         (index) => faker.image.image(height: 100, width: 100),
    //       ),
    //       dateTime: faker.date
    //           .dateTime(minYear: 1971, maxYear: DateTime.now().year)
    //           .toIso8601String(),
    //     );
    //   },
    // );

    reports.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );

    return reports;
  }

  void sortBy(SortReportBy sortBy) {
    switch (sortBy) {
      case SortReportBy.fromA2Z:
        final result = state.value!;
        final sorted =
            result.sortedBy<String>((element) => element.description);
        state = AsyncData(sorted);
        return;
      case SortReportBy.timeFromFarToClose:
        final result = state.value!;
        final sorted = result.sortedBy<num>(
          (e) => DateTime.parse(e.dateTime).millisecondsSinceEpoch,
        );
        state = AsyncData(sorted);
        return;
      case SortReportBy.timeFromCloseToFar:
        final result = state.value!;
        final sorted = result.sortedBy<num>(
          (element) => DateTime.parse(element.dateTime).millisecondsSinceEpoch,
        );
        final reversed = sorted.reversed.toList();
        state = AsyncData(reversed);
        return;
    }
  }
}
