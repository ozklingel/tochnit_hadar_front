import 'package:hadar_program/src/services/api/madadim/get_forgotten_apprentices.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:hadar_program/src/views/primary/pages/home/views/widgets/success_dialog_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import '../../../../../services/networking/http_service.dart';
import '../../chat_box/error_dialog.dart';
part 'apprentices_status_controller.g.dart';

@Riverpod(
  dependencies: [
    GetForgottenApprentices,
  ],
)
class ApprenticesStatusController extends _$ApprenticesStatusController {
  @override
  FutureOr<ApprenticeStatusDto> build() async {
    final result = await ref.watch(getForgottenApprenticesProvider.future);

    return result;
  }

  Future<void> export(phone,context) async {
        final response =await HttpService.exportApprenticeStatus(phone,'1999-09-09'); 
    if (response.statusCode == 200) {
          downloadCSV(response.body);
             showFancyCustomDialog(context);
         }
         else{
             showAlertDialog(context);
         }         

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

