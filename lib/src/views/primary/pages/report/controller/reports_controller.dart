import 'package:collection/collection.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/reports_form/get_reports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_controller.g.dart';

enum SortReportBy {
  fromA2Z,
  timeFromCloseToFar,
  timeFromFarToClose,
}

@Riverpod(
  dependencies: [
    GetReports,
  ],
)
class ReportsController extends _$ReportsController {
  @override
  FutureOr<List<ReportDto>> build() async {
    final reports = await ref.watch(getReportsProvider.future);

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
