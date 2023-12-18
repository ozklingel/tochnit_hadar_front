import 'dart:math';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
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
    // ignore: unused_local_variable
    final request =
        ref.watch(dioProvider).get('userProfile_form/myApprentices');

    await Future.delayed(const Duration(milliseconds: 200));

    final reports = List.generate(
      44,
      (index) {
        return ReportDto(
          id: faker.guid.guid(),
          description: faker.lorem.sentence(),
          apprentices: List.generate(
            13,
            (index) => Consts.mockApprenticeGuids[
                Random().nextInt(Consts.mockApprenticeGuids.length)],
          ),
          reportEventType: ReportEventType.values[Random().nextInt(6)],
          attachments: List.generate(
            11,
            (index) => faker.image.image(height: 100, width: 100),
          ),
          dateTime: faker.date
              .dateTime(minYear: 1971, maxYear: DateTime.now().year)
              .millisecondsSinceEpoch,
        );
      },
    );

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
        final sorted = result.sortedBy<num>((e) => e.dateTime);
        state = AsyncData(sorted);
        return;
      case SortReportBy.timeFromCloseToFar:
        final result = state.value!;
        final sorted = result.sortedBy<num>((element) => element.dateTime);
        final reversed = sorted.reversed.toList();
        state = AsyncData(reversed);
        return;
    }
  }
}
