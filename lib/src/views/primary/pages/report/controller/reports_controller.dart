import 'dart:math';

import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_controller.g.dart';

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
          apprentices: List.generate(13, (index) => faker.guid.guid()),
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
}
