import 'package:faker/faker.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_controller.g.dart';

@Riverpod(
  dependencies: [
    ApprenticesController,
  ],
)
class TasksController extends _$TasksController {
  @override
  Future<List<TaskDto>> build() async {
    final apprentices =
        ref.watch(apprenticesControllerProvider).valueOrNull ?? [];

    return List.generate(
      23,
      (index) {
        apprentices.shuffle();

        return TaskDto(
          id: faker.guid.guid(),
          reportEventType: TaskType
              .values[faker.randomGenerator.integer(TaskType.values.length)],
          apprentice: apprentices.firstOrNull ?? const ApprenticeDto(),
          dateTime: faker.date
              .dateTime(
                minYear: 1972,
                maxYear: DateTime.now().year,
              )
              .millisecondsSinceEpoch,
        );
      },
    );
  }
}
