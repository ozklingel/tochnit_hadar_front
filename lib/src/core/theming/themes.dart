import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

ThemeData get appThemeLight {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'rubik',
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyles.bodyB4Bold,
    ),
    chipTheme: ChipThemeData(
      iconTheme: const IconThemeData(
        color: AppColors.grey1,
      ),
      labelStyle: TextStyles.bodyB2Bold.copyWith(
        color: AppColors.grey1,
      ),
      side: const BorderSide(
        color: AppColors.blue07,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyles.bodyB3,
      errorStyle: TextStyles.bodyB1Bold,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(36),
        borderSide: const BorderSide(color: AppColors.shades300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(36),
        borderSide: const BorderSide(
          color: AppColors.grey5,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyles.bodyB41Bold,
      bodyMedium: TextStyles.bodyB2,
      displayMedium: TextStyles.bodyB2Bold,
      displaySmall: TextStyles.bodyB1Bold,
      // ?
      bodySmall: TextStyle(
        fontSize: 13,
        fontVariations: [
          FontVariation('wght', 400),
        ],
      ),
    ),
  );
}
