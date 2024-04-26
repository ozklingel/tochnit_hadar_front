import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apprentices_status_controller.g.dart';

@Riverpod(
  dependencies: [
    GetForgottenApprentices,
  ],
)
class ApprenticesStatusController extends _$ApprenticesStatusController {
  @override
  FutureOr<ApprenticeStatusDto> build() async {
    final result = await ref.watch(getForgottenApprenticesProvider.future);

    return result;
  }

  Future<void> export() async {
    Toaster.unimplemented();
  }
}
