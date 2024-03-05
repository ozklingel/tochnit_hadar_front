import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/reports_form/get_reports.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'reports_controller.g.dart';

enum SortReportBy {
  abcAscending,
  timeFromCloseToFar,
  timeFromFarToClose,
}

@Riverpod(
  dependencies: [
    GetReports,
    DioService,
    GoRouterService,
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
      case SortReportBy.abcAscending:
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

  Future<bool> create(ReportDto report) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.addReport,
        data: {
          'List_of_repored': report.recipients,
          'event_type': report.reportEventType.name,
          'description': report.description,
          'attachments': report.attachments,
          'date': report.dateTime,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getReportsProvider);

        ref.read(goRouterServiceProvider).go('/reports');

        return true;
      }
    } catch (e) {
      Logger().e('failed to add report', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> edit(ReportDto report) async {
    try {
      final result = await ref.read(dioServiceProvider).put(
        Consts.editReport,
        queryParameters: {
          'reportId': report.id,
        },
        data: {
          'List_of_repored': report.recipients,
          'event_type': report.reportEventType.name,
          'description': report.description,
          'attachments': report.attachments,
          'date': report.dateTime,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getReportsProvider);

        ref.read(goRouterServiceProvider).go('/reports');

        return true;
      }
    } catch (e) {
      Logger().e('failed to edit report', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> delete(ReportDto report) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.editReport,
        queryParameters: {
          'reportId': report.id,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getReportsProvider);

        ref.read(goRouterServiceProvider).go('/reports');

        return true;
      }
    } catch (e) {
      Logger().e('failed to delete report', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
