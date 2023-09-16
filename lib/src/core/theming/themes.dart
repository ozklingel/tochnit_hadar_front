import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

abstract class TextStyles {
  static const bodyB4 = TextStyle(
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB4Bold = TextStyle(
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const bodyB41Bold = TextStyle(
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const messageTitle = TextStyle(
    fontSize: 18,
    color: AppColors.shade09,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const bodyB3 = TextStyle(
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB2 = TextStyle(
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB2Bold = TextStyle(
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB1Bold = TextStyle(
    fontSize: 12,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB1 = TextStyle(
    fontSize: 12,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const aospBodySmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    color: AppColors.grey5,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );
}

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
        borderSide: const BorderSide(color: AppColors.shade03),
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
