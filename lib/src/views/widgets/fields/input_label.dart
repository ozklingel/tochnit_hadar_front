import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/views/widgets/items/details_row_item.dart';

class InputFieldContainer extends StatelessWidget {
  const InputFieldContainer({
    super.key,
    this.label = '',
    this.isRequired = false,
    this.labelStyle,
    required this.child,
    this.data,
  });

  final bool isRequired;
  final String label;
  final Widget child;
  final TextStyle? labelStyle;
  final String? data;

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return DetailsRowItem(
        label: label,
        data: data!,
      );
    }

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
                  style: TextStyle(color: AppColors.red2),
                ),
              ],
            ],
            style: labelStyle ??
                TextStyles.s12w500.copyWith(
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
