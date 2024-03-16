import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apprentices_status_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class ApprenticesStatusController extends _$ApprenticesStatusController {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> export() async {
    Toaster.unimplemented();
  }
}
