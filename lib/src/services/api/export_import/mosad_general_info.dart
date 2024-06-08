import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/secondary/institutions/models/institution_pdf_export.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mosad_general_info.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
@Deprecated('in favor of just getting the pdf from server side')
class MosadGeneralInfo extends _$MosadGeneralInfo {
  @override
  Future<InstitutionExportPdfDto> build() async {
    final result = await ref.watch(dioServiceProvider).get(
          Consts.mosadGeneralInfo,
        );

    final parsed = InstitutionExportPdfDto.fromJson(result.data);

    ref.keepAlive();

    return parsed;
  }
}
