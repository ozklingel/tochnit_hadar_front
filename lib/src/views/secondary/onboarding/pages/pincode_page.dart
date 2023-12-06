import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/utils/hooks/interval.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

const _kPinCodeLength = 6;
const _timerDuration = 60;

class OnboardingPinCodePage extends HookWidget {
  const OnboardingPinCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinCodeController = useTextEditingController();
    final timer = useState(_timerDuration);
    final isVoiceMFA = useState(false);
    final isRememberMeChecked = useState(false);

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
                if (isVoiceMFA.value) ...[
                  const TextSpan(text: 'שלחנו לך קוד למספר'),
                  const TextSpan(text: '\n'),
                ] else ...[
                  const TextSpan(text: 'שלחנו לך קוד בהודעה קולית'),
                  const TextSpan(text: '\n'),
                  const TextSpan(text: 'למספר'),
                ],
                const TextSpan(text: ' '),
                TextSpan(
                  text: '050-1234567',
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
            child: PinCodeTextField(
              appContext: context,
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
          SizedBox(
            height: 24,
            child: timer.value == 0
                ? TextButton(
                    onPressed: () => timer.value = _timerDuration,
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
          CheckboxListTile.adaptive(
            value: isRememberMeChecked.value,
            focusNode: FocusNode(skipTraversal: true),
            onChanged: (val) =>
                isRememberMeChecked.value = !isRememberMeChecked.value,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'זכור אותי בכניסות הבאות',
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ),
          TextButton(
            onPressed: () => isVoiceMFA.value = !isVoiceMFA.value,
            child: Text(
              isVoiceMFA.value
                  ? 'שלחו לי את הקוד בהודעה קולית'
                  : 'שלחו לי את הקוד בהודעת טקסט',
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
                : () => Toaster.unimplemented(),
          ),
        ],
      ),
    );
  }
}
