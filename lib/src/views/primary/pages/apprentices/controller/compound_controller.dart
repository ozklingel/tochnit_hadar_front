import 'package:hadar_program/src/models/compound/compound.dto.dart';
import 'package:hadar_program/src/services/api/base/get_bases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compound_controller.g.dart';

@Riverpod(
  dependencies: [
    GetCompoundList,
  ],
)
class CompoundController extends _$CompoundController {
  @override
  FutureOr<List<CompoundDto>> build() async {
    final compounds = await ref.watch(getCompoundListProvider.future);

    ref.keepAlive();

    return compounds;
  }
}
