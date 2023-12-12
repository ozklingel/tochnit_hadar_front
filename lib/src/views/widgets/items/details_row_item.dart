import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';

class DetailsRowItem extends StatelessWidget {
  const DetailsRowItem({
    super.key,
    required this.label,
    required this.data,
    this.labelWidth = 80,
    this.dataWidth = 190,
    this.contact,
    this.onTapPhone,
  });

  final String label;
  final String data;
  final double labelWidth;
  final double dataWidth;
  final ContactDto? contact;
  final VoidCallback? onTapPhone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: TextStyles.s14w400.copyWith(
              color: AppColors.grey5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: dataWidth,
          child: contact == null
              ? Text(
                  data,
                  style: TextStyles.s14w400,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                )
              : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: contact?.fullName),
                      WidgetSpan(
                        child: TextButton(
                          onPressed: onTapPhone,
                          child: Text(contact?.phone ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
