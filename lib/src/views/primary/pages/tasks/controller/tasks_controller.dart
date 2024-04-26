import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/api/tasks_form/get_tasks.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'tasks_controller.g.dart';

@Riverpod(
  dependencies: [
    GetTasks,
    GoRouterService,
    DioService,
    StorageService,
  ],
)
class TasksController extends _$TasksController {
  @override
  Future<List<TaskDto>> build() async {
    final tasks = await ref.watch(getTasksProvider.future);

    return tasks;
  }

  Future<bool> create({
    required String apprenticeId,
    required TaskDto task,
  }) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.createTask,
        data: {
          'userId': ref.read(storageServiceProvider.notifier).getUserPhone(),
          'apprenticeid': apprenticeId,
          'subject': task.subject,
          'date': task.dateTime,
          'description': task.details,
          'details': task.details,
          'event': task.event.name,
          'frequency': task.frequency.name,
          'title': task.title.isEmpty ? task.event.name : task.title,
          'status': task.status.name,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);

        // ref.read(goRouterServiceProvider).go('/tasks');
        ref.read(goRouterServiceProvider).pop();

        return true;
      }
    } catch (e) {
      Logger().e('failed to create task', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> edit(TaskDto task) async {
    try {
      final result = await ref.read(dioServiceProvider).put(
        Consts.editTask,
        queryParameters: {
          'taskId': task.id,
        },
        data: {
          'subject': task.subject,
          'date': task.dateTime,
          'description': task.details,
          'event': task.event.name,
          'frequency': task.frequency.name,
          'title': task.title.isEmpty ? task.event.name : task.title,
          'status': task.status.name,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);

        ref.read(goRouterServiceProvider).go('/tasks');

        return true;
      }
    } catch (e) {
      Logger().e('failed to update task', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> delete(TaskDto task) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.deleteTask,
        data: {
          'taskId': task.id,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);

        ref.read(goRouterServiceProvider).pop();

        return true;
      }
    } catch (e) {
      Logger().e('failed to delete task', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
