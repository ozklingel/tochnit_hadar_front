import 'package:collection/collection.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'institutions_controller.g.dart';

enum SortInstitutionBy {
  fromA2Z,
  scoreLow2High,
  scoreHigh2Low,
}

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class InstitutionsController extends _$InstitutionsController {
  @override
  FutureOr<List<InstitutionDto>> build() async {
    // ignore: unused_local_variable
    final request =
        ref.watch(dioServiceProvider).get('userProfile_form/myApprentices');

    return [];
  }

  void sortBy(SortInstitutionBy sortBy) {
    if (state.valueOrNull == null) {
      return;
    }

    switch (sortBy) {
      case SortInstitutionBy.fromA2Z:
        final result = state.value!;
        final sorted = result.sortedBy((element) => element.name);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreLow2High:
        final result = state.value!;
        final sorted = result.sortedBy<num>((e) => e.score);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreHigh2Low:
        final result = state.value!;
        final sorted = result.sortedBy<num>((element) => element.score);
        final reversed = sorted.reversed.toList();
        state = AsyncData(reversed);
        return;
    }
  }
}
