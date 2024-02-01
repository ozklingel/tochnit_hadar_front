import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/arch/flags_service.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_tasks.g.dart';

@Riverpod(
  dependencies: [
    FlagsService,
    DioService,
  ],
)
class GetTasks extends _$GetTasks {
  @override
  FutureOr<List<TaskDto>> build() async {
    final flags = ref.watch(flagsServiceProvider);

    if (flags.isMock) {
      return flags.tasks;
    }

    final request = await ref.watch(dioServiceProvider).get(Consts.getAllTasks);

    final result = (request.data as List<dynamic>)
        .map(
          (e) => TaskDto.fromJson(e),
        )
        .toList();

    return result;
  }
}
