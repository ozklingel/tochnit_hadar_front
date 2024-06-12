import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/models/institution/institution.dto.dart';
import 'package:hadar_program/src/services/api/institutions/get_institutions.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:http_parser/http_parser.dart';
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
    GetInstitutions,
    DioService,
    StorageService,
    GoRouterService,
  ],
)
class InstitutionsController extends _$InstitutionsController {
  @override
  FutureOr<List<InstitutionDto>> build() async {
    final institutions = await ref.watch(getInstitutionsProvider.future);

    return institutions;
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
    final phone = ref.read(storageServiceProvider.notifier).getUserPhone();

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
        ref.read(goRouterServiceProvider).pop();

        ref.invalidate(getInstitutionsProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to create institution', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> addFromExcel(PlatformFile file) async {
    if (file.bytes == null) {
      throw ArgumentError('missing param bytes');
    }

    final formData = FormData.fromMap({
      "file": kIsWeb
          ? MultipartFile.fromBytes(
              file.bytes as List<int>,
              filename: file.name,
              contentType: MediaType.parse('multipart/form-data'),
            )
          : await MultipartFile.fromFile(
              file.path!,
              filename: file.name,
              contentType: MediaType.parse('multipart/form-data'),
            ),
    });

    try {
      final result = await ref.watch(dioServiceProvider).put(
            Consts.addInstitutionFromExcel,
            data: formData,
          );
      if (result.data['result'] == 'success') {
        Toaster.error('הושלם בהצלחה');
        ref.read(goRouterServiceProvider).go('/home');

        return true;
      }
    } catch (e) {
      Logger().e('failed to add institution excel', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return false;
  }

  Future<bool> delete(String id) async {
    try {
      final result = await ref.read(dioServiceProvider).post(
            Consts.deleteInstitution,
            data: jsonEncode({
              'entityId': id,
            }),
          );

      if (['success', 'sucess'].contains(result.data['result'])) {
        // ref.read(goRouterServiceProvider).go('/home');
        ref.invalidate(getInstitutionsProvider);

        return true;
      }
    } catch (e) {
      Logger().e('failed to delete institution', error: e);
      Sentry.captureException(e, stackTrace: StackTrace.current);
      Toaster.error(e);
    }

    return false;
  }

  Future<Uint8List> getPdf({
    required id,
  }) async {
    try {
      final request = await ref.read(dioServiceProvider).get(
        Consts.institutionPdf,
        queryParameters: {
          'institution_id': id,
        },
      );

      if (request.data is Map<String, dynamic> &&
          request.data['result'] ==
              "error-no coordinator or such institution") {
        throw ArgumentError('bad id?');
      }

      if (request.data.toString().isNotEmpty) {
        // https://stackoverflow.com/questions/28565242/convert-uint8list-to-string-with-dart/56363052#56363052
        // /final list = <int>[];

        // request.data.toString().runes.forEach((rune) {
        //   if (rune >= 0x10000) {
        //     rune -= 0x10000;
        //     int firstWord = (rune >> 10) + 0xD800;
        //     list.add(firstWord >> 8);
        //     list.add(firstWord & 0xFF);
        //     int secondWord = (rune & 0x3FF) + 0xDC00;
        //     list.add(secondWord >> 8);
        //     list.add(secondWord & 0xFF);
        //   } else {
        //     list.add(rune >> 8);
        //     list.add(rune & 0xFF);
        //   }
        // });

        // final bytes = Uint8List.fromList(list);

        // Here you have `Uint8List` available

        // Bytes to UTF-16 string
        // final buffer = StringBuffer();
        // for (int i = 0; i < bytes.length;) {
        //   int firstWord = (bytes[i] << 8) + bytes[i + 1];
        //   if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        //     int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        //     buffer.writeCharCode(
        //       ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000,
        //     );
        //     i += 4;
        //   } else {
        //     buffer.writeCharCode(firstWord);
        //     i += 2;
        //   }
        // }

        // return bytes;

        return base64Decode(request.data.toString());
      }
    } catch (e) {
      Logger().e('failed to fetch institution pdf', error: e);
      Sentry.captureException(e);
      Toaster.error(e);
    }

    return Uint8List.fromList([]);
  }
}
