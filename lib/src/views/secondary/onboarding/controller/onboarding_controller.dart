import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

typedef FirstOnboarding = bool;
typedef IsResponseSuccess = bool;

enum AddressRegion {
  none,
  center,
  jerusalem,
  north,
  south,
  yehuda;

  String get name {
    switch (this) {
      case AddressRegion.none:
        return '';
      case AddressRegion.center:
        return 'אזור המרכז';
      case AddressRegion.jerusalem:
        return 'ירושלים והסביבה';
      case AddressRegion.north:
        return 'אזור הצפון';
      case AddressRegion.south:
        return 'אזור הדרום';
      case AddressRegion.yehuda:
        return 'יהודה ושומרון';
    }
  }
}

@Riverpod(
  dependencies: [
    DioService,
    Storage,
  ],
)
class OnboardingController extends _$OnboardingController {
  @override
  void build() {
    ref.watch(dioServiceProvider);
  }

  Future<IsResponseSuccess> getOtp({
    required String phone,
  }) async {
    try {
      final result = await ref.watch(dioServiceProvider).get(
        '/onboarding_form/getOTP',
        queryParameters: {
          'created_by_phone': phone.fixRawPhone,
        },
      );

      if (result.statusCode == 200) {
        return true;
      }
    } catch (e) {
      // Logger().d('otp', error: e);
      rethrow;
    }

    return false;
  }

  Future<(IsResponseSuccess, FirstOnboarding)> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final result = await ref.watch(dioServiceProvider).get(
        '/onboarding_form/verifyOTP',
        queryParameters: {
          'created_by_phone': phone.fixRawPhone,
          'otp': otp,
        },
      );

      if (result.statusCode == 200) {
        final accessToken = result.data['result'].toString();
        final firstOnboarding = result.data['firsOnboarding'] as bool;

        await ref.read(storageProvider).requireValue.setString(
              Consts.userPhoneKey,
              phone.fixRawPhone,
            );

        await ref.read(storageProvider).requireValue.setString(
              Consts.accessTokenKey,
              accessToken,
            );

        await ref.read(storageProvider).requireValue.setBool(
              Consts.firstOnboardingKey,
              firstOnboarding,
            );

        return (true, firstOnboarding);
      }
    } catch (e) {
      rethrow;
    }

    return (false, false);
  }

  Future<IsResponseSuccess> onboardingFillUserInfo({
    required String email,
    required DateTime dateOfBirth,
    required String city,
  }) async {
    final userPhone = ref
        .read(
          storageProvider,
        )
        .requireValue
        .getString(
          Consts.userPhoneKey,
        );

    try {
      await ref.watch(dioServiceProvider).put(
        '/setEntityDetails_form/setByType',
        data: {
          "typeOfSet": "Onboarding",
          "entityId": userPhone,
          "atrrToBeSet": {
            "phone": userPhone,
            "email": email,
            "birthday": dateOfBirth.toIso8601String(),
          },
        },
      );

      await ref.read(storageProvider).requireValue.setBool(
            Consts.firstOnboardingKey,
            false,
          );

      return true;
    } catch (e) {
      return false;
    }
  }
}

extension _FixPhoneX on String {
  String get fixRawPhone => '972${substring(1, 10)}';
}
