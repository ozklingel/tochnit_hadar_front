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
          width: 120,
          child: Text(
            label,
            style: TextStyles.bodyB2.copyWith(
              color: AppColors.grey5,
            ),
          ),
        ),
        SizedBox(
          width: 220,
          child: Text(
            data,
            style: TextStyles.bodyB2,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
