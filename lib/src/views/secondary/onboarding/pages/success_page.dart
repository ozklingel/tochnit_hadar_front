import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/widgets/loading_widget.dart';

class OnboardingSuccessPage extends StatelessWidget {
  const OnboardingSuccessPage.otpSuccess({
    super.key,
  })  : topText = 'נוה לוי, זיהינו אותך בהצלחה!',
        bottomText = 'מיד נעבור לשלב קצר של הגדרות ראשונית של האפליקציה ';

  const OnboardingSuccessPage.lastPage({
    super.key,
  })  : topText = 'יופי, סיימנו!',
        bottomText = 'מיד תעבור למסך הבית, שם תוכל להתחיל לעבוד.';

  final String topText;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoadingWidget(),
        const SizedBox(height: 24),
        Text(
          topText,
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        Text(
          bottomText,
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
      ],
    );
  }
}
