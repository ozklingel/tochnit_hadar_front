import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_message_controller.g.dart';

@Riverpod(
  dependencies: [
    GetApprentices,
  ],
)
class NewMessageController extends _$NewMessageController {
  @override
  FutureOr<List<ApprenticeDto>> build({
    required String searchTerm,
  }) async {
    final apprentices = await ref.watch(getApprenticesProvider.future);

    final filtered = apprentices
        .where((element) => element.fullName.contains(searchTerm))
        .toList();

    return filtered;
  }
}
