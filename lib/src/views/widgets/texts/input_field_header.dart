import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class InputFieldHeader extends StatelessWidget {
  const InputFieldHeader({
    super.key,
    this.label = '',
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: TextStyles.s12w500,
            children: [
              TextSpan(
                text: label,
                style: TextStyles.s12w500cGray5,
              ),
              if (isRequired) ...[
                const TextSpan(text: ' '),
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
