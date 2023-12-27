import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/logo_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/personal_details_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/phone_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/pincode_page.dart';
import 'package:hadar_program/src/views/secondary/onboarding/pages/success_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({
    super.key,
    required this.isOnboarding,
  });

  final bool isOnboarding;

  @override
  Widget build(BuildContext context, ref) {
    final pageController = usePageController(initialPage: isOnboarding ? 4 : 0);
    final phoneController = useState('');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: PageView(
          controller: pageController,
          physics: kDebugMode
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          children: [
            OnboardingPage0Logo(
              onLoaded: () => pageController.nextPage(
                duration: Consts.defaultDurationM,
                curve: Curves.linear,
              ),
            ),
            OnboardingPage1Phone(
              onSuccess: (phone) {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );
                phoneController.value = phone;
              },
            ),
            OnboardingPage2PinCode(
              onSuccess: (isFirstOnboarding) {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );

                if (isFirstOnboarding) {
                  pageController.nextPage(
                    duration: Consts.defaultDurationM,
                    curve: Curves.linear,
                  );
                } else {
                  const HomeRouteData().go(context);
                }
              },
              phone: phoneController.value,
            ),
            OnboardingSuccessPage.page3otpSuccess(
              onLoaded: () => pageController.nextPage(
                duration: Consts.defaultDurationM,
                curve: Curves.linear,
              ),
            ),
            OnboardingPage4PersonalDetails(
              onSuccess: () {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );
              },
            ),
            OnboardingSuccessPage.page4lastPage(
              onLoaded: () {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );

                const HomeRouteData().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
