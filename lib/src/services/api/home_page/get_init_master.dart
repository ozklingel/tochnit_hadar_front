import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/ahrai_home.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_init_master.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetInitMaster extends _$GetInitMaster {
  @override
  Future<AhraiHomeDto> build() async {
    final request =
        await ref.watch(dioServiceProvider).get(Consts.getHomePageInitMaster);

    final result = AhraiHomeDto.fromJson(request.data);

    ref.keepAlive();

    // Logger().d(processed);

    return result;
  }
}
