import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

typedef ShouldOnboard = bool;

@Riverpod(
  dependencies: [
    dio,
    storage,
  ],
)
class OnboardingController extends _$OnboardingController {
  @override
  void build() {
    ref.watch(dioProvider);
  }

  Future<bool> getOtp({
    required String phone,
  }) async {
    try {
      final result = await ref.watch(dioProvider).get(
        '/onboarding_form/getOTP',
        queryParameters: {
          'created_by_phone': phone,
        },
      );

      if (result.statusCode == 200) {
        return true;
      }
    } catch (e) {
      Logger().d('otp', error: e);
    }

    return true;
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final result = await ref.watch(dioProvider).get(
        '/onboarding_form/verifyOTP',
        queryParameters: {
          'created_by_phone': phone,
          'otp': otp,
        },
      );

      if (result.statusCode == 200) {
        final accessToken = result.data['result'] as String;
        final firsOnboarding = result.data['firsOnboarding'] as bool;

        ref
            .read(
              storageProvider,
            )
            .requireValue
            .setString(
              Consts.userPhoneKey,
              phone,
            );

        ref.read(storageProvider).requireValue.setString(
              Consts.accessTokenKey,
              accessToken,
            );

        return firsOnboarding;
      }
    } catch (e) {
      Logger().d('otp', error: e);
      rethrow;
    }

    return true;
  }
}
