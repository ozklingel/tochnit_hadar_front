import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/api/user_profile_form/my_apprentices.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_users_controller.g.dart';

@Riverpod(
  dependencies: [
    GetApprentices,
    GetFilteredUsers,
  ],
)
class FindUsersController extends _$FindUsersController {
  @override
  FutureOr<List<PersonaDto>> build({
    required String searchTerm,
  }) async {
    final users = await ref.watch(
      getFilteredUsersProvider(
        const FilterDto(
          roles: [
            'רכזי מוסד',
            'רכזי אשכול',
            'מלוים',
          ],
        ),
      ).future,
    );

    final apprentices = await ref.watch(getApprenticesProvider.future);

    final filteredApprenticesBySearch = apprentices
        .where((element) => element.fullName.contains(searchTerm))
        .toList();

    final filteredApprenticesByIds = filteredApprenticesBySearch
        .where((element) => users.contains(element.id))
        .toList();

    Logger().d('users.length: ${users.length}'
        '\napprentices ${apprentices.length}'
        '\nfilteredApprenticesBySearch ${filteredApprenticesBySearch.length}'
        '\nfilteredApprenticesByIds ${filteredApprenticesByIds.length}');

    return filteredApprenticesByIds;
  }
}
