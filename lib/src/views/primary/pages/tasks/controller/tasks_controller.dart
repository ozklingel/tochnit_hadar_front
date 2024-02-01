import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/api/tasks_form/get_tasks.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class TasksController extends _$TasksController {
  @override
  Future<List<TaskDto>> build() async {
    final tasks = await ref.watch(getTasksProvider.future);

    return tasks;
  }
}
