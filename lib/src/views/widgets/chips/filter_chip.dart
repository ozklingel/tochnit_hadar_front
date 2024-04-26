import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = true,
  });

  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FilterChip(
        backgroundColor: isSelected ? AppColors.blue06 : null,
        avatar: isSelected ? const Icon(Icons.close) : null,
        label: Text(text),
        onSelected: (val) => onTap(),
      ),
    );
  }
}
