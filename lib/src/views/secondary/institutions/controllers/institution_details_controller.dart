import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_apprentice_and_melave.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'institution_details_controller.g.dart';

enum SortInstitutionBy {
  fromA2Z,
  scoreLow2High,
  scoreHigh2Low,
}

@Riverpod(
  dependencies: [
    GetApprenticesAndMelavim,
    GetFilteredUsers,
  ],
)
class InstitutionDetailsController extends _$InstitutionDetailsController {
  var _filters = const FilterDto();

  @override
  FutureOr<List<ApprenticeDto>> build({required String id}) async {
    final apprentices =
        await ref.watch(getApprenticesAndMelavimProvider(id: id).future);

    ref.keepAlive();

    return apprentices;
  }

  FutureOr<bool> filterUsers(FilterDto filter) async {
    _filters = filter;

    if (_filters.isEmpty) {
      ref.invalidateSelf();

      return true;
    }

    try {
      final request = await ref.read(getFilteredUsersProvider(_filters).future);

      state = AsyncData(
        state.requireValue
            .where((element) => request.contains(element.id))
            .toList(),
      );

      return true;
    } catch (e) {
      Logger().e('failed to filter users', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
