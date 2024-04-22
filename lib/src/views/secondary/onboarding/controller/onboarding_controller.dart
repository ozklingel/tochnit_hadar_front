import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'dart:convert';  // Include this at the top of your file

part 'onboarding_controller.g.dart';

@Riverpod(
  dependencies: [
    DioService,
    StorageService,
  ],
)
class OnboardingController extends _$OnboardingController {
  @override
  void build() {
    ref.watch(dioServiceProvider);
  }

  Future<bool> getOtp({
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
      } else if (result.statusCode == 401) {
        return false;
      }
    } catch (e) {
      Logger().d('otp', error: e);
      rethrow;
    }

    return false;
  }

  Future<bool> getOtpWhatsapp({
    required String phone,
  }) async {
    try {
      final result = await ref.watch(dioServiceProvider).get(
        '/onboarding_form/getOTP_whatsapp',
        queryParameters: {
          'created_by_phone': phone.fixRawPhone,
        },
      );

      if (result.statusCode == 200) {
        return true;
      } else if (result.statusCode == 401) {
        return false;
      }
    } catch (e) {
      // Logger().d('otp', error: e);
      rethrow;
    }

    return false;
  }

Future<bool> verifyRegistered() async {
  final phone = ref
      .read(storageServiceProvider)
      .requireValue
      .getString(Consts.userPhoneKey);

  final result = await ref.watch(dioServiceProvider).get(
    '/userProfile_form/getProfileAtributes',
    queryParameters: {
      'userId': phone,
    },
  );

  if (result.statusCode == 200) {
    final data = json.decode(result.data);
    final email = data['email'] as String?;
    debugPrint('Email: $email');
    print('Email: $email');
    return email != null; // Return true if email is not null, false otherwise
  } else {
    return false; // Return false if the API request fails
  }
}
  
  Future<({bool isResponseSuccess, bool isFirstOnboarding})> verifyOtp({
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

        await ref.read(storageServiceProvider).requireValue.setString(
              Consts.userPhoneKey,
              phone.fixRawPhone,
            );

        await ref.read(storageServiceProvider).requireValue.setString(
              Consts.accessTokenKey,
              accessToken,
            );

        await ref.read(storageServiceProvider).requireValue.setBool(
              Consts.isFirstOnboardingKey,
              firstOnboarding,
            );

        return (
          isResponseSuccess: true,
          isFirstOnboarding: firstOnboarding,
        );
      }
    } catch (e) {
      rethrow;
    }

    return (
      isResponseSuccess: false,
      isFirstOnboarding: false,
    );
  }

  Future<bool> onboardingFillUserInfo({
    required String email,
    required DateTime dateOfBirth,
    required String city,
  }) async {
    final userPhone = ref
        .read(
          storageServiceProvider,
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
            "birthday": DateFormat('yyyy-MM-dd').format(dateOfBirth),
          },
        },
      );

      await ref.read(storageServiceProvider).requireValue.setBool(
            Consts.isFirstOnboardingKey,
            false,
          );

      return true;
    } catch (e) {
      return false;
    }
  }
}

extension _FixPhoneX on String {
  // new changes after deciding with oz to omit the country code 972
  // String get fixRawPhone => '972${substring(1, 10)}';
  String get fixRawPhone => substring(1, 10);
}
