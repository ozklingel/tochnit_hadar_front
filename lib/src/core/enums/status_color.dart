import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

enum StatusColor {
  grey(100),
  green(200),
  orange(300),
  red(400),
  invis(999);

  const StatusColor(this.value);
  final int value;

  Color toColor() {
    return this == StatusColor.green
        ? AppColors.green2
        : this == StatusColor.red
            ? AppColors.red2
            : this == StatusColor.orange
                ? AppColors.yellow1
                : Colors.transparent;
  }
}
