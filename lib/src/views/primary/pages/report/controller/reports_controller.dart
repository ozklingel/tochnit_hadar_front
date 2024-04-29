import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:hadar_program/src/services/api/home_page/get_init_master.dart';
import 'package:hadar_program/src/services/api/reports_form/filter_recipients.dart';
import 'package:hadar_program/src/services/api/reports_form/filter_reports.dart';
import 'package:hadar_program/src/services/api/reports_form/get_reports.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
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
    StorageService,
    FilterReports,
    FilterRecipients,
  ],
)
class ReportsController extends _$ReportsController {
  var _filters = const FilterDto();

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

  Future<bool> create(
    ReportDto report, {
    bool redirect = true,
  }) async {
    Logger().d('start creating report', error: report);

    try {
      final result = await ref.read(dioServiceProvider).post(
            Consts.addReport,
            data: jsonEncode({
              'userId':
                  ref.read(storageServiceProvider.notifier).getUserPhone(),
              'List_of_repored': report.recipients,
              'date': report.dateTime,
              'event_type': report.reportEventType.name,
              'description': report.description,
              'attachments': report.attachments,
            }),
          );

      if (result.data['result'] == 'success') {
        ref.invalidate(getReportsProvider);
        ref.invalidate(getInitMasterProvider);

        // if (redirect) {
        //   ref.read(goRouterServiceProvider).go('/reports');
        // }

        ref.read(goRouterServiceProvider).pop();

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
    Logger().d('start editing report', error: report);

    try {
      final result = await ref.read(dioServiceProvider).put(
        Consts.editReport,
        queryParameters: {
          'reportId': report.id,
        },
        data: {
          'reported_on': report.recipients,
          "allreadyread": false,
          'attachments': report.attachments,
          'visit_date': report.dateTime,
          'event_type': report.reportEventType.name,
          'description': report.description,
          'title': report.reportEventType.name,
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

  Future<bool> delete(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError('bad report id delete');
    }

    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.deleteReport,
        data: {
          'reportId': ids,
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

  FutureOr<bool> filterReports(FilterDto filter) async {
    _filters = filter;

    if (_filters.isEmpty) {
      ref.invalidateSelf();

      return true;
    }

    try {
      final request = await ref.read(filterReportsProvider(_filters).future);

      state = AsyncData(
        state.requireValue
            .where((element) => request.contains(element.id))
            .toList(),
      );

      return true;
    } catch (e) {
      Logger().e('failed to filter reports', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<List<String>> filterRecipients(FilterDto filter) async {
    try {
      final request = await ref.read(filterRecipientsProvider(_filters).future);

      if (request.isNotEmpty) {
        return request;
      }
    } catch (e) {
      Logger().e('failed to filter reports', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return [];
  }
}
