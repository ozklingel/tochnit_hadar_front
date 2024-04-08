import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FilterChip(
        backgroundColor: AppColors.blue06,
        avatar: const Icon(Icons.close),
        label: Text(text),
        onSelected: (val) => onTap(),
      ),
    );
  }
}
