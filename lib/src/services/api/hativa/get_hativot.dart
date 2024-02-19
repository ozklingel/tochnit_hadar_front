import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_hativot.g.dart';

// todo: add to find_objects_page
@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetHativotList extends _$GetHativotList {
  @override
  Future<List<String>> build() async {
    final result =
        await ref.watch(dioServiceProvider).get(Consts.getAllHativot);

    final parsed = result.data as List<dynamic>;

    final processed = parsed.map((e) => e.toString()).toList();

    ref.keepAlive();

    return processed;
  }
}
