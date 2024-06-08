import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/api/user_profile_form/get_personas.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_users_controller.g.dart';

@Riverpod(
  dependencies: [
    GetPersonas,
    GetFilteredUsers,
  ],
)
class FindUsersController extends _$FindUsersController {
  @override
  FutureOr<List<PersonaDto>> build({
    required String searchTerm,
  }) async {
    final filteredIds = await ref.watch(
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

    final total = await ref.watch(getPersonasProvider.future);

    final filteredApprenticesBySearch = total
        .where((element) => element.fullName.contains(searchTerm))
        .toList();

    final filteredApprenticesByIds = filteredApprenticesBySearch
        .where((element) => filteredIds.contains(element.id))
        .toList();

    Logger().d(
      'filtered: ${filteredIds.length}'
      '\n'
      'total ${total.length}'
      '\n'
      'filtered search ${filteredApprenticesBySearch.length}'
      '\n'
      'filtered ids ${filteredApprenticesByIds.length}',
    );

    return filteredApprenticesByIds;
  }
}
