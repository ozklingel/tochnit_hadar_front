import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/logo_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/personal_details_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/phone_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/pincode_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/success_page.dart';

class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: PageView(
          controller: pageController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            OnboardingLogoPage(),
            OnboardingPhonePage(),
            OnboardingPinCodePage(),
            OnboardingSuccessPage.otpSuccess(),
            OnboardingPersonalDetails(),
            OnboardingSuccessPage.lastPage(),
          ],
        ),
      ),
    );
  }
}
