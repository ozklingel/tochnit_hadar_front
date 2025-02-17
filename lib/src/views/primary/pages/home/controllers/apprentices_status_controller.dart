import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/forgotten_apprentice.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/networking/http_service.dart';

part 'apprentices_status_controller.g.dart';

@Riverpod(
  dependencies: [
    StorageService,
    GetForgottenApprentices,
  ],
)
class ApprenticesStatusController extends _$ApprenticesStatusController {
  @override
  FutureOr<ForgottenApprenticeDto> build() async {
    final result = await ref.watch(getForgottenApprenticesProvider.future);

    return result;
  }

  Future<bool> export() async {
    final phone = ref.watch(storageServiceProvider.notifier).getUserPhone();

    final response =
        await HttpService.exportApprenticeStatus(phone, '1999-09-09');
    if (response.statusCode == 200) {
      downloadCSV(response.body);
      return true;
    }

    return false;
  }

  downloadCSV(String file) async {
    // Convert your CSV string to a Uint8List for downloading.
    Uint8List bytes = Uint8List.fromList(utf8.encode(file));

    // This will download the file on the device.
    await FileSaver.instance.saveFile(
      name: 'exported_TH', // you can give the CSV file name here.
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }
}
