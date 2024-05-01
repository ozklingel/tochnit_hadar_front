import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/utils/hooks/interval.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/controller/onboarding_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

const _kPinCodeLength = 6;
const _timerDuration = 60;
final pinErrorProvider = StateProvider<bool>((ref) => false);

class OnboardingPage2PinCode extends HookConsumerWidget {
  const OnboardingPage2PinCode({
    super.key,
    required this.onSuccess,
    required this.phone,
  });

  final void Function(bool isFirstOnboarding) onSuccess;
  final String phone;

  String _platformMFA(bool isWhatsAppMFA) => isWhatsAppMFA ? 'סמס' : 'ווטסאפ';

  @override
  Widget build(BuildContext context, ref) {
    final pinCodeController = useTextEditingController();
    final timer = useState(_timerDuration);
    final isWhatsAppMFA = useState(false);
    final isRememberMeChecked = useState(false);

    void toggleMFA() {
      isWhatsAppMFA.value = !isWhatsAppMFA.value; // Toggle the state
    }

    useListenable(pinCodeController);

    useInterval(
      () {
        if (timer.value > 0) {
          timer.value--;
        }
      },
      const Duration(seconds: 1),
    );

    // TODO(yeo):
    // 'state' is deprecated and shouldn't be used. Will be removed in 3.0.0. Use either `ref.watch(provider)` or `ref.read(provider.notifier)` instead.
    // Try replacing the use of the deprecated member with the replacement.
    // ignore: deprecated_member_use
    final hasError = ref.watch(pinErrorProvider.state);

    // bool hasError = false;
    return FocusTraversalGroup(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.logomark.image(),
            Text(
              'קוד אימות',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'שלחנו לך ב${_platformMFA(!isWhatsAppMFA.value)}\n למספר ',
                  ),
                  TextSpan(
                    text: phone,
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  const TextSpan(text: '\nיש להקיש אותו כאן למטה'),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: <Widget>[
                    PinCodeTextField(
                      appContext: context,
                      autoFocus: true,
                      controller: pinCodeController,
                      autoDisposeControllers: false,
                      length: _kPinCodeLength,
                      hintCharacter: '*',
                      textStyle: TextStyle(
                        color: hasError.state
                            ? AppColors.error500
                            : AppColors
                                .shade09, // Specify the desired color here
                      ),
                      cursorColor: AppColors.shade09,
                      pinTheme: PinTheme(
                        inactiveColor: hasError.state
                            ? AppColors.error500
                            : AppColors.shade09,
                        selectedColor: hasError.state
                            ? AppColors.error500
                            : AppColors.shade09,
                        activeColor: hasError.state
                            ? AppColors.error500
                            : AppColors.shade09,
                        errorBorderColor: AppColors.error500,
                        selectedBorderWidth: 2,
                        inactiveBorderWidth: 1,
                        activeBorderWidth: 1,
                      ),
                      onChanged: (value) {
                        hasError.state = false;
                      },
                    ),

                    const SizedBox(
                      height: 0,
                    ), // Use this to adjust the vertical space between the PinCodeTextField and the Text widget

                    Center(
                      // Centers the text horizontally
                      child: hasError.state
                          ? const Text(
                              "קוד אימות שגוי, רוצה לנסות שוב?",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: Colors.red, fontSize: 11),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ), // Use this to adjust the vertical space between the PinCodeTextField and the Text widget
            SizedBox(
              height: 24,
              child: timer.value == 0
                  ? TextButton(
                      onPressed: () async {
                        await ref
                            .read(onboardingControllerProvider.notifier)
                            .getOtp(phone: phone);
                        timer.value = _timerDuration;
                        pinCodeController.text = 'CCCCCCCCCC';
                      },
                      child: Text(
                        'שליחת קוד חדש',
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                    )
                  : Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'לא קיבלתם קוד?',
                              style: Theme.of(context).textTheme.displayMedium!,
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text:
                                  'נוכל לשלוח לך קוד חדש בעוד ${timer.value.toString()} שניות',
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),
            ),
            ListTile(
              focusNode: FocusNode(skipTraversal: true),
              title: Text(
                'זכור אותי בכניסות הבאות',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              leading: Checkbox(
                value: isRememberMeChecked.value,
                onChanged: (val) =>
                    isRememberMeChecked.value = !isRememberMeChecked.value,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (isWhatsAppMFA.value) {
                  await ref
                      .read(onboardingControllerProvider.notifier)
                      .getOtp(phone: phone);
                } else {
                  await ref
                      .read(onboardingControllerProvider.notifier)
                      .getOtpWhatsapp(phone: phone);
                }
                timer.value = _timerDuration;
                pinCodeController.text = '';
                toggleMFA();
              },
              child: Text(
                'שלחו לי קוד ב${_platformMFA(isWhatsAppMFA.value)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.blue02,
                    ),
              ),
            ),
            LargeFilledRoundedButton(
              label: 'המשך',
              onPressed: pinCodeController.text.length != _kPinCodeLength
                  ? null
                  : () async {
                      final result = await ref
                          .read(onboardingControllerProvider.notifier)
                          .verifyOtp(
                            phone: phone,
                            otp: pinCodeController.text,
                          );

                      if (!result.isResponseSuccess) {
                        // TODO(yeo):
                        // 'state' is deprecated and shouldn't be used. Will be removed in 3.0.0. Use either `ref.watch(provider)` or `ref.read(provider.notifier)` instead.
                        // Try replacing the use of the deprecated member with the replacement.
                        // ignore: deprecated_member_use
                        ref.read(pinErrorProvider.state).state = true;
                        // // ignore: use_build_context_synchronously
                        // showDialog(
                        //   // ignore: use_build_context_synchronously
                        //   context: context,
                        //   builder: (context) {
                        //     return const AlertDialog.adaptive(
                        //       content: Text('תקלה'),
                        //     );
                        //   },
                        // );
                      } else {
                        onSuccess(result.isFirstOnboarding);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
