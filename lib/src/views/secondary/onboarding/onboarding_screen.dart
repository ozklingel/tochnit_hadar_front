import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('התרחשה שגיאה'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.thinking.image(),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('חזרה'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final pageController = usePageController(initialPage: isOnboarding ? 3 : 0);
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
            OnboardingPagePhone(
              onSuccess: (phone) {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );
                phoneController.value = phone;
              },
              onFailure: _showErrorDialog,
            ),
            OnboardingPagePinCode(
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
              onFailure: _showErrorDialog,
              phone: phoneController.value,
            ),
            OnboardingSuccessPage.otpSuccess(
              onLoaded: () => pageController.nextPage(
                duration: Consts.defaultDurationM,
                curve: Curves.linear,
              ),
            ),
            OnboardingPagePersonalDetails(
              onSuccess: () {
                pageController.nextPage(
                  duration: Consts.defaultDurationM,
                  curve: Curves.linear,
                );
              },
            ),
            OnboardingSuccessPage.lastPage(
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
