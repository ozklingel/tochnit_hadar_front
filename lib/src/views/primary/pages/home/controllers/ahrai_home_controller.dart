import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ahrai_home_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class AhraiHomeController extends _$AhraiHomeController {
  @override
  Future<AhraiHomeDto> build() async {
    final request =
        await ref.watch(dioServiceProvider).get(Consts.homePageInitMaster);

    final result = AhraiHomeDto.fromJson(request.data);

    return result;
  }
}
