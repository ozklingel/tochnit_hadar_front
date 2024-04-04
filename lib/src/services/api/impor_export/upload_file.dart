import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_file.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class UploadFile extends _$UploadFile {
  @override
  Future<String> build(PlatformFile file) async {
    // final fileName = file.path.split('/').last;

    if (file.bytes == null) {
      throw ArgumentError('missing param bytes');
    }

    // Logger().d('upload file', error: file.bytes!.toList().length);

    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes!.toList(),
        filename: file.path,
        contentType: MediaType.parse('multipart/form-data'),
      ),
    });

    final result = await ref.watch(dioServiceProvider).post(
          Consts.uploadFile,
          data: formData,
        );

    final parsed = result.data as Map<String, dynamic>;

    final processed = parsed['image path'] as List<dynamic>;

    // ref.keepAlive();

    return processed.firstOrNull ?? '';
  }
}
