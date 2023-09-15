import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/themes.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: const Size(double.infinity, 60),
        backgroundColor: AppColors.blue02,
        disabledBackgroundColor: AppColors.blue07,
      ),
      child: const Text(
        'המשך',
        style: TextStyles.bodyB4Bold,
      ),
    );
  }
}
