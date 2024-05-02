import 'package:hadar_program/src/services/api/home_page/get_init_master.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ahrai_home_controller.g.dart';

@Riverpod(
  dependencies: [
    GetInitMaster,
  ],
)
class AhraiHomeController extends _$AhraiHomeController {
  @override
  Future<AhraiHomeDto> build() async {
    final result = await ref.watch(getInitMasterProvider.future);

    return result;
  }
}
