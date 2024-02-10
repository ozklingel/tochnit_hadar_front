import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/api/tasks_form/get_tasks.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_controller.g.dart';

@Riverpod(
  dependencies: [
    GetTasks,
  ],
)
class TasksController extends _$TasksController {
  @override
  Future<List<TaskDto>> build() async {
    final tasks = await ref.watch(getTasksProvider.future);

    return tasks;
  }

  Future<bool> createNewTask(TaskDto task) async {
    Toaster.error('BACKEND CREATE TASK NOT IMPLEMENETED');

    return false;
  }

  Future<bool> updateExistingTask(TaskDto task) async {
    Toaster.error('BACKEND UPDATE TASK NOT IMPLEMENETED');

    return false;
  }

  Future<bool> deleteExistingTask(TaskDto task) async {
    Toaster.error('BACKEND DELETE TASK NOT IMPLEMENETED');

    return false;
  }
}
