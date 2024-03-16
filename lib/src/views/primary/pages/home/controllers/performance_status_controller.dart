import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'performance_status_controller.g.dart';

@Riverpod(
  dependencies: [],
)
class PerformanceStatusController extends _$PerformanceStatusController {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> export() async {
    Toaster.unimplemented();
  }
}
