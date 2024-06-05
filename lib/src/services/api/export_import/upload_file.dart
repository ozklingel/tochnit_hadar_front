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
    if (file.bytes == null) {
      throw ArgumentError('missing param bytes');
    }

    // MediaType(
    //       [
    //         'jpg',
    //         'jpeg',
    //         'png',
    //       ].contains(filetype)
    //           ? 'image'
    //           // e.g. xlsx
    //           : 'application',
    //       filetype,
    //     )

    final formData = FormData.fromMap({
      // file.path is not supported on web, so we use fromBytes instead:
      // https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ
      "file": MultipartFile.fromBytes(
        file.bytes as List<int>,
        filename: file.name,
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
