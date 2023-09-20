import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class InputFieldLabel extends StatelessWidget {
  const InputFieldLabel({
    super.key,
    this.label = '',
    this.isRequired = false,
    required this.child,
  });

  final bool isRequired;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              if (isRequired) ...[
                const TextSpan(text: ' '),
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.red02),
                ),
              ],
            ],
            style: TextStyles.bodyB1Bold.copyWith(
              color: AppColors.gray5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
