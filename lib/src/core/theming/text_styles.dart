import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

const _kFontFamily = 'rubik';

abstract class TextStyles {
  static const homeName = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 32,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const titleB4BoldX = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 600),
    ],
    color: AppColors.gray2,
  );

  static const bodyB4 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB4Bold = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const bodyB41 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB41Bold = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const homeGreeting = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const messageTitle = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.shade09,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const smallHeading = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const cardTitle = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB3 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB3Bold = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const cardSubtitle = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const bodyB2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB2Bold = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const subtitle = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const baseApprentices = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 13,
    color: AppColors.blue05,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB1Bold = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB1 = TextStyle(
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

  static const actionButton = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );
}
