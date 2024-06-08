import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class DetailsRowItem extends StatelessWidget {
  const DetailsRowItem({
    super.key,
    required this.label,
    required this.data,
    this.labelWidth = 80,
    this.dataWidth = 190,
    this.contactName = '',
    this.contactPhone = '',
    this.onTapPhone,
    this.onTapData,
  });

  final String label;
  final String data;
  final double labelWidth;
  final double dataWidth;
  final String contactName;
  final String contactPhone;
  final VoidCallback? onTapPhone;
  final VoidCallback? onTapData;

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
          child: contactName.isEmpty
              ? Builder(
                  builder: (context) {
                    final child = Text(
                      data,
                      style: TextStyles.s14w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    );

                    return Row(
                      children: [
                        if (onTapData == null) ...[
                          const SizedBox(width: 12),
                          child,
                        ] else
                          TextButton(
                            onPressed: onTapData,
                            child: child,
                          ),
                      ],
                    );
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(contactName),
                    TextButton(
                      onPressed: onTapPhone,
                      child: Text(contactPhone),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
