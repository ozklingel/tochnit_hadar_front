import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'new_or_edit_institution_controller.g.dart';

enum SortInstitutionBy {
  fromA2Z,
  scoreLow2High,
  scoreHigh2Low,
}

@Riverpod(
  dependencies: [
    GetInstitutions,
    DioService,
    StorageService,
    GoRouterService,
  ],
)
class NewOrEditInstitutionController extends _$NewOrEditInstitutionController {
  @override
  String build(String id) {
    return id;
  }

  FutureOr<bool> updateLogo(String url) async {
    try {
      final request = await ref.read(dioServiceProvider).put(
        Consts.updateInstitution,
        queryParameters: {
          'mosad_id': state,
        },
        data: {
          'logo_path': url,
        },
      );

      Logger().i(request.data, error: id);

      if (request.data['result'] == 'success') {
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
}
