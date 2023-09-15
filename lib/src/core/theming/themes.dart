import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

abstract class TextStyles {
  static const bodyB4Bold = TextStyle(
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );
  static const bodyB3 = TextStyle(
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB41Bold = TextStyle(
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB2 = TextStyle(
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
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

  static const bodyB2Bold = TextStyle(
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );
}

ThemeData get appThemeLight {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'rubik',
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
