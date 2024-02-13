import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_bases.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetCompoundList extends _$GetCompoundList {
  @override
  Future<List<CompoundDto>> build() async {
    final result =
        await ref.watch(dioServiceProvider).get(Consts.getAllCompounds);

    final parsed = result.data as List<dynamic>;

    final processed = parsed.map((e) => CompoundDto.fromJson(e)).toList();

    ref.keepAlive();

    return processed;
  }
}
