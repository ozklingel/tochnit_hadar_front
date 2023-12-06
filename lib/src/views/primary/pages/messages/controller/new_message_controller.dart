import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/apprentices_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_message_controller.g.dart';

@Riverpod(
  dependencies: [
    ApprenticesController,
  ],
)
class NewMessageController extends _$NewMessageController {
  @override
  FutureOr<List<ApprenticeDto>> build({
    required String searchTerm,
  }) async {
    final all = await ref.watch(apprenticesControllerProvider.future);

    final filtered =
        all.where((element) => element.fullName.contains(searchTerm)).toList();

    return filtered;
  }
}
