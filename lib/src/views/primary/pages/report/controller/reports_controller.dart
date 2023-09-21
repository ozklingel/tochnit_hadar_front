import 'dart:math';

import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_controller.g.dart';

@Riverpod(
  dependencies: [
    ApprenticesController,
  ],
)
class ReportsController extends _$ReportsController {
  @override
  FutureOr<List<ReportDto>> build() async {
    // await Future.delayed(const Duration(milliseconds: 200));

    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    final reports = List.generate(
      44,
      (index) {
        apprentices.shuffle();

        return ReportDto(
          id: faker.guid.guid(),
          description: faker.lorem.sentence(),
          apprentices: apprentices.take(Random().nextInt(5)).toList(),
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
