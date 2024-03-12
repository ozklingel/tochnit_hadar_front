import 'package:collection/collection.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'institutions_controller.g.dart';

enum SortInstitutionBy {
  fromA2Z,
  scoreLow2High,
  scoreHigh2Low,
}

@Riverpod(
  dependencies: [
    DioService,
    GoRouterService,
    GetInstitutions,
  ],
)
class InstitutionsController extends _$InstitutionsController {
  @override
  FutureOr<List<InstitutionDto>> build() async {
    final institutions =
        await ref.watch(dioServiceProvider).get(Consts.getAllInstitutions);

    final parsed = (institutions.data as List<dynamic>)
        .map((e) => InstitutionDto.fromJson(e))
        .toList();

    return parsed;
  }

  void sortBy(SortInstitutionBy sortBy) {
    if (state.valueOrNull == null) {
      return;
    }

    switch (sortBy) {
      case SortInstitutionBy.fromA2Z:
        final result = state.value!;
        final sorted = result.sortedBy((element) => element.name);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreLow2High:
        final result = state.value!;
        final sorted = result.sortedBy<num>((e) => e.score);
        state = AsyncData(sorted);
        return;
      case SortInstitutionBy.scoreHigh2Low:
        final result = state.value!;
        final sorted = result.sortedBy<num>((element) => element.score);
        final reversed = sorted.reversed.toList();
        state = AsyncData(reversed);
        return;
    }
  }

  Future<bool> create(InstitutionDto obj) async {
    final phone = ref.read(storageProvider.notifier).getUserPhone();

    try {
      final result = await ref.read(dioServiceProvider).post(
        Consts.addInstitution,
        data: {
          "owner_id": phone,
          "phone": phone,
          "city": obj.address.city,
          "name": obj.name,
          "eshcol": obj.address.region,
          "contact_phone": obj.rakazPhoneNumber,
          "contact_name": obj.roshMehinaName,
          "admin_name": obj.adminName,
          "admin_phone": obj.adminPhoneNumber,
          "roshYeshiva_name": obj.roshMehinaName,
          "shluha": obj.shluha,
          "roshYeshiva_phone": obj.roshMehinaPhoneNumber,
        },
      );

      if (result.data['result'] == 'success') {
        ref.invalidate(getInstitutionsProvider);

        // ref.read(goRouterServiceProvider).pop();

        return true;
      }
    } catch (e) {
      Logger().e('failed to create instution', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }
}
