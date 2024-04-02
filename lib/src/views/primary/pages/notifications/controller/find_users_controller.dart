import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_users_controller.g.dart';

@Riverpod(
  dependencies: [
    GetApprentices,
  ],
)
class FindUsersController extends _$FindUsersController {
  @override
  FutureOr<List<PersonaDto>> build({
    required String searchTerm,
  }) async {
    final apprentices = await ref.watch(getApprenticesProvider.future);

    final filtered = apprentices
        .where((element) => element.fullName.contains(searchTerm))
        .toList();

    return filtered;
  }
}
