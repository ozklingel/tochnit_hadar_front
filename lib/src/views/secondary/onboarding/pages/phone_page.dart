import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/views/secondary/onboarding/controller/onboarding_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingPage1Phone extends HookConsumerWidget {
  const OnboardingPage1Phone({
    super.key,
    required this.onSuccess,
  });

  final void Function(String phone) onSuccess;

  @override
  Widget build(BuildContext context, ref) {
    final phoneTextEditingController = useTextEditingController();
    final phoneFocusNode = useFocusNode();
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final isFormValid = useState(false);
    final isFormFails = useState(false);

    useEffect(
      () {
        void listener() {
          isFormValid.value = formKey.currentState?.validate() ?? false;
        }

        phoneTextEditingController.addListener(listener);
        return () => phoneTextEditingController.removeListener(listener);
      },
      [phoneTextEditingController],
    );

    useListenable(phoneFocusNode);

    return FocusTraversalGroup(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.logomark.image(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'התחברות',
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'הכניסו את מספר הנייד שלכם ונשלח לכם קוד לאימות',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'מספר הנייד',
                      ),
                      TextSpan(
                        text: '',
                        style: TextStyle(color: AppColors.red2),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: AppColors.red2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: phoneTextEditingController,
                  focusNode: phoneFocusNode,
                  autofocus: true,
                  style: TextStyles.s16w400cGrey2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (_) {
                    if (phoneTextEditingController.text.length != 10) {
                      return 'מספר הנייד חייב להיות בעל 10 ספרות';
                    }
                    if (isFormFails.value) {
                      var str = 'מתנצלים, אבל לא זיהינו את מספר הנייד הזה.';
                      str += "\n";
                      str += 'ייתכן שהתבלבת באחד התווים, או שנרשמת ממספר אחר.';
                      return str;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.blue02),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.blue02),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.blue02,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    counter: isFormValid.value
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedDefaultTextStyle(
                              duration: Consts.defaultDurationM,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: phoneFocusNode.hasFocus
                                        ? AppColors.blue02
                                        : AppColors.grey5,
                                  ),
                              child: const Text(
                                'הקלד מספר טלפון נייד ללא רווחים וסימנים',
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const Spacer(),
            LargeFilledRoundedButton(
              label: 'המשך',
              onPressed: isFormValid.value
                  ? () async {
                      final result = await ref
                          .read(onboardingControllerProvider.notifier)
                          .getOtp(phone: phoneTextEditingController.text);
                      if (result) {
                        onSuccess(phoneTextEditingController.text);
                      } else {
                        isFormFails.value = true;
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}