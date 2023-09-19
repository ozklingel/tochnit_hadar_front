import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class LargeFilledRoundedButton extends StatelessWidget {
  const LargeFilledRoundedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.blue02,
    this.foregroundColor = Colors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: const Size(double.infinity, 60),
        side: const BorderSide(
          color: AppColors.blue03,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: backgroundColor,
        disabledBackgroundColor: AppColors.blue07,
      ),
      child: Text(
        label,
        style: TextStyles.bodyB4Bold.copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }
}
