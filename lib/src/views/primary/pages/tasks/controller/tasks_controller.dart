import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/api/tasks_form/get_tasks.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/views/tasks_screen.dart';
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
  Future<List<TaskDto>> build() async =>
      await ref.watch(getTasksProvider.future);

  Future<bool> create({
    required TaskDto task,
    required String? subject, // the subject of the task, i.e. apprentice id
  }) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.createTask,
        data: {
          'user_id': ref.read(storageServiceProvider.notifier).getUserPhone(),
          'subject': subject ?? task.subject.join(','),
          'event': task.event.isOther ? task.title : task.event.name,
          'details': task.details,
          'date': task.dateTime,
          'frequency_end': task.frequencyEnd.name,
          'frequency_meta': task.frequencyMeta.name,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);
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
          'task_id': task.id,
        },
        data: {
          'subject': task.subject.join(','),
          'date': task.dateTime,
          'details': task.details,
          'event': task.event.isOther ? task.title : task.event.name,
          'frequency_end': task.frequencyEnd.name,
          'frequency_meta': task.frequencyMeta.name,
          'status': task.status.name,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);
        ref.read(goRouterServiceProvider).go(TasksScreen.path);
        return true;
      }
    } catch (e) {
      Logger().e('failed to update task', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }
    return false;
  }

  Future<bool> toggleTodo(TaskDto task) async {
    try {
      final status = task.status.isDone ? TaskStatus.todo : TaskStatus.done;
      final result = await ref.read(dioServiceProvider).put(
        Consts.editTask,
        queryParameters: {
          'task_id': task.id,
        },
        data: {
          'status': status.name,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getTasksProvider);
        ref.read(goRouterServiceProvider).go(TasksScreen.path);
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
          'task_id': task.id,
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

  Future<bool> deleteMany(List<String>? taskIds) async {
    if (taskIds == null || taskIds.isEmpty) return false;
    if (state is! AsyncData || state.value == null) return false;

    final tasks =
        state.value!.where((element) => taskIds.contains(element.id)).toList();
    try {
      for (var task in tasks) {
        Logger().d('deleting task: ${task.id}');
        final result = await ref.read(dioServiceProvider).post(
          Consts.deleteTask,
          data: {
            'task_id': task.id,
          },
        );

        if (result.data['result'] != 'success') return false;
      }

      ref.invalidate(getTasksProvider);
      return true;
    } catch (e) {
      Logger().e('failed to delete tasks', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> setToReadStatus(TaskDto task) async {
    if (task.alreadyRead) {
      return true;
    }

    try {
      await ref.read(dioServiceProvider).post(
        Consts.setTaskWasRead,
        data: {
          'task_id': task.id,
        },
      );
      ref.invalidate(getTasksProvider);

      return true;
    } catch (e) {
      Sentry.captureException(e);

      return false;
    }
  }
}
