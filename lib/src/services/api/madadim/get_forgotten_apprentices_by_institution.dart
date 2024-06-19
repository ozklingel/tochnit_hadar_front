import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/forgotten_mosad_apprentices.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_forgotten_apprentices_by_institution.g.dart';

/* example response
{
   "apprentice_list": [
        {
            "gap": 100,
            "id": 544816500
        },
        {
            "gap": 100,
            "id": 544816502
        },
        {
            "gap": 100,
            "id": 544816501
        },
        {
            "gap": 100,
            "id": 544887500
        },
        {
            "gap": 100,
            "id": 544866501
        },
        {
            "gap": 100,
            "id": 544814502
        },
        {
            "gap": 100,
            "id": 544316115
        },
        {
            "gap": 100,
            "id": 544316116
        },
        {
            "gap": 100,
            "id": 544316117
        },
        {
            "gap": 100,
            "id": 544316125
        },
        {
            "gap": 100,
            "id": 544316126
        },
        {
            "gap": 100,
            "id": 544316127
        },
        {
            "gap": 14,
            "id": 544816598
        },
        {
            "gap": 12,
            "id": 549247617
        },
        {
            "gap": 26,
            "id": 549247618
        }
    ],
    "percentage": 0
}
*/

@Riverpod(
  dependencies: [
    // FlagsService,
    DioService,
  ],
)
class GetForgottenApprenticesByInstitution
    extends _$GetForgottenApprenticesByInstitution {
  @override
  FutureOr<ForgottenMosadApprenticesDto> build({
    required String institutionId,
  }) async {
    // final flags = ref.watch(flagsServiceProvider);

    // if (flags.isMock) {
    //   return flags.;
    // }

    final request = await ref.watch(dioServiceProvider).get(
      Consts.getForgotenApprenticesByInstitution,
      queryParameters: {
        'institutionId': institutionId,
      },
    );

    final parsed = ForgottenMosadApprenticesDto.fromJson(request.data);

    ref.keepAlive();

    return parsed;
  }
}
