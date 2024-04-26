import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/views/primary/pages/home/models/apprentice_status.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_forgotten_apprentices.g.dart';

/* example response
{
    "forgotenApprentice_count": [
        {
            "name": "בני דוד דרך אבות",
            "value": 9
        },
        {
            "name": "בני דוד עלי",
            "value": 6
        },
        {
            "name": "בני דוד הבקעה",
            "value": 10
        }
    ],
    "forgotenApprentice_total": 25
}
*/

@Riverpod(
  dependencies: [
    // FlagsService,
    DioService,
  ],
)
class GetForgottenApprentices extends _$GetForgottenApprentices {
  @override
  FutureOr<ApprenticeStatusDto> build() async {
    // final flags = ref.watch(flagsServiceProvider);

    // if (flags.isMock) {
    //   return flags.;
    // }

    final request =
        await ref.watch(dioServiceProvider).get(Consts.getForgotenApprentices);

    final parsed = ApprenticeStatusDto.fromJson(request.data);

    return parsed;
  }
}
