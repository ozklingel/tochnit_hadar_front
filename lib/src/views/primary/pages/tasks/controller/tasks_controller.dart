import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
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
      Consts.mockTasksGuids.length,
      (index) {
        apprentices.shuffle();

        return TaskDto(
          id: Consts.mockTasksGuids[index],
          title: faker.company.name(),
          details: faker.lorem.sentence(),
          frequency: faker.lorem.sentence(),
          isComplete: faker.randomGenerator.boolean(),
          reportEventType: TaskType
              .values[faker.randomGenerator.integer(TaskType.values.length)],
          apprentice: apprentices.firstOrNull ?? const ApprenticeDto(),
          dateTime: faker.date
              .dateTime(
                minYear: 1972,
                maxYear: DateTime.now().year,
              )
              .toIso8601String(),
        );
      },
    );
  }
}
