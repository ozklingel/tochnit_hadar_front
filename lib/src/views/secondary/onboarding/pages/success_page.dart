import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';

class OnboardingSuccessPage extends HookWidget {
  const OnboardingSuccessPage.page3otpSuccess({
    super.key,
    required this.onLoaded,
  })  : topText = 'זיהינו אותך בהצלחה!',
        bottomText = 'מיד נעבור לשלב קצר של הגדרות ראשונית של האפליקציה ';

  const OnboardingSuccessPage.page4lastPage({
    super.key,
    required this.onLoaded,
  })  : topText = 'יופי, סיימנו!',
        bottomText = 'מיד תעבור למסך הבית, שם תוכל להתחיל לעבוד.';

  final String topText;
  final String bottomText;
  final VoidCallback onLoaded;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        Timer.periodic(const Duration(seconds: 3), (timer) {
          timer.cancel();
          onLoaded();
        });

        return null;
      },
      [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Assets.images.loader.image(),
        ),
        const SizedBox(height: 24),
        Text(
          topText,
          style: Theme.of(context).textTheme.titleMedium!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          bottomText,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
