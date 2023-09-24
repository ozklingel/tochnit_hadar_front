import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class DetailsRowItem extends StatelessWidget {
  const DetailsRowItem({
    super.key,
    required this.label,
    required this.data,
  });

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyles.s14w400.copyWith(
              color: AppColors.grey5,
            ),
          ),
        ),
        SizedBox(
          width: 212,
          child: Text(
            data,
            style: TextStyles.s14w400,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
