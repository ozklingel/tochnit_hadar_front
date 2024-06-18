import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/filter/filter.dto.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/api/search_bar/get_filtered_users.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
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
    DioService,
    GetFilteredUsers,
    GetInstitutions,
  ],
)
class InstitutionDetailsController extends _$InstitutionDetailsController {
  var _filters = const FilterDto();

  @override
  FutureOr<InstitutionDto> build({required String id}) async {
    final institutions = await ref.watch(getInstitutionsProvider.future);

    // final apprentices =
    //     await ref.watch(getApprenticesAndMelavimProvider(id: id).future);

    final result = institutions.singleWhere(
      (element) => element.id == id,
      orElse: () => const InstitutionDto(),
    );

    // Logger().d(institutions, error: result);

    ref.keepAlive();

    return result;
  }

  FutureOr<bool> updateLogo(String url) async {
    final institution = state.valueOrNull ?? const InstitutionDto();

    // Logger().d(institution, error: state);

    if (institution.isEmpty) {
      const error = 'missing institution';
      Logger().e('failed to update institution logo', error: error);
      Sentry.captureException(error);
      Toaster.error(error);

      return false;
    }

    try {
      final request = await ref.read(dioServiceProvider).put(
        Consts.updateInstitution,
        queryParameters: {
          'mosad_Id': institution.id,
        },
        data: {
          'avatar': url,
        },
      );

      // Logger().i(request.data, error: id);

      if (['success', 'sucess'].contains(request.data['result'])) {
        ref.invalidate(getInstitutionsProvider);
      }

      return true;
    } catch (e) {
      Logger().e('failed to update institution logo', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  FutureOr<List<String>?> filterUsers(FilterDto filter) async {
    _filters = filter;

    if (_filters.isEmpty) {
      ref.invalidateSelf();

      return [];
    }

    try {
      final request = await ref.read(getFilteredUsersProvider(_filters).future);

      // state = AsyncData(
      //   state.requireValue
      //       .where((element) => request.contains(element.id))
      //       .toList(),
      // );

      return request;
    } catch (e) {
      Logger().e('failed to filter users', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return null;
  }
}
