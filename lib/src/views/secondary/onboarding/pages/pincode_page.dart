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

class OnboardingPage2PinCode extends HookConsumerWidget {
  const OnboardingPage2PinCode({
    super.key,
    required this.onSuccess,
    required this.phone,
  });

  final void Function(bool isFirstOnboarding) onSuccess;
  final String phone;

  @override
  Widget build(BuildContext context, ref) {
    final pinCodeController = useTextEditingController();
    final timer = useState(_timerDuration);
    final isWhatsAppMFA = useState(false);
    final isRememberMeChecked = useState(false);
    final buttonText = useState('שלח לי את הקוד דרך הווצאפ');

    void toggleMFA() {
      isWhatsAppMFA.value = !isWhatsAppMFA.value; // Toggle the state
      buttonText.value = isWhatsAppMFA.value ? 'שלח לי את הקוד דרך סמס' : 'שלח לי את הקוד דרך הווצאפ';
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
                  if (isWhatsAppMFA.value) ...[
                    const TextSpan(text: 'שלחנו לך דרך ווצאפ'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'למספר'),
                  ] else ...[
                    const TextSpan(text: 'שלחנו לך דרך סמס'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'למספר'),
                  ],
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: phone,
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  const TextSpan(text: '\n'),
                  const TextSpan(text: 'יש להקיש אותו כאן למטה'),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  autoFocus: true,
                  controller: pinCodeController,
                  autoDisposeControllers: false,
                  length: _kPinCodeLength,
                  hintCharacter: '*',
                  cursorColor: AppColors.shade09,
                  pinTheme: PinTheme(
                    inactiveColor: AppColors.shade09,
                    selectedColor: AppColors.shade09,
                    activeColor: AppColors.shade09,
                    errorBorderColor: AppColors.error500,
                    selectedBorderWidth: 2,
                    inactiveBorderWidth: 1,
                    activeBorderWidth: 1,
                  ),
                ),
              ),
            ),
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
                await ref
                    .read(onboardingControllerProvider.notifier)
                    .getOtpWhatsapp(phone: phone);
                timer.value = _timerDuration;
                pinCodeController.text = '';
                toggleMFA();
              },
              child: Text(
                buttonText.value,
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
                        // ignore: use_build_context_synchronously
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return const AlertDialog.adaptive(
                              content: Text('תקלה'),
                            );
                          },
                        );
                      }
                      onSuccess(result.isFirstOnboarding);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
