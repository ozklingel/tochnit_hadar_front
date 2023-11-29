import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

const _kFontFamily = 'rubik';

abstract class TextStyles {
  static const s32w500cWhite = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 32,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s24w600 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 600),
    ],
    color: AppColors.gray2,
  );

  static const s24w400 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s24w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const s22w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 22,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const s20w400 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s20w500 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s20w300cWhite = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s18w600cShade09 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.shade09,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const s18w400cGray1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s18w500cGray1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s16w400cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w400cGrey5 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey5,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s16w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s14w400 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s14w400cblue2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.blue02,
  );

  static const s14w500 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s14w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s13w400cBlue05 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 13,
    color: AppColors.blue05,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w500 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s12w500cGray5 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.gray5,
  );

  static const bodyB1 = TextStyle(
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey5fRoboto = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    color: AppColors.grey5,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s11w500 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );
}
