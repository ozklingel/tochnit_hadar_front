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
    dio,
    storage,
  ],
)
class OnboardingController extends _$OnboardingController {
  @override
  void build() {
    ref.watch(dioProvider);
  }

  Future<IsResponseSuccess> getOtp({
    required String phone,
  }) async {
    try {
      final result = await ref.watch(dioProvider).get(
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
      final result = await ref.watch(dioProvider).get(
        '/onboarding_form/verifyOTP',
        queryParameters: {
          'created_by_phone': phone.fixRawPhone,
          'otp': otp,
        },
      );

      if (result.statusCode == 200) {
        final accessToken = result.data['result'].toString();
        final firstOnboarding = result.data['firsOnboarding'] as bool;

        await ref
            .read(
              storageProvider,
            )
            .requireValue
            .setString(
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

  Future<IsResponseSuccess> onboardingInfo({
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
      await ref.watch(dioProvider).put(
        '/setEntityDetails_form/setByType',
        queryParameters: {
          "typeOfSet": "apprenticeProflie",
          "entityId": "+$userPhone",
          "atrrToBeSet": {
            "accompany_id": "+$userPhone",
            "name": "bbb",
            "last_name": "df",
            "phone": "fd",
            "email": email,
            "birthday": dateOfBirth.toIso8601String(),
            "marriage_status": true,
            "marriage_date": "1995-07-06",
            "wife_name": "fg",
            "wife_phone": "er",
            "city_id": 0,
            "address": "yu",
            "father_name": "ui",
            "father_phone": "io",
            "father_email": "hj",
            "mother_name": "jk",
            "mother_phone": "gh",
            "mother_email": "df",
            "high_school_name": "sd",
            "high_school_teacher": "sd",
            "high_school_teacher_phone": "as",
            "pre_army_institution": "xc",
            "teacher_grade_a": "bv",
            "teacher_grade_a_phone": "cv",
            "teacher_grade_b": "zx",
            "teacher_grade_b_phone": "sd",
            "institution_id": 0,
            "hadar_plan_session": 1,
            "base_address": "nb",
            "unit_name": "bn",
            "army_role": "bv",
            "serve_type": "cv",
            "recruitment_date": "1995-08-08",
            "release_date": "1995-08-08",
          },
        },
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
