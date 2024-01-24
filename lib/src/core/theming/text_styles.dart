import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

const _kFontFamily = 'rubik';

abstract class TextStyles {
  static const s34w400cGreen = TextStyle(
    fontFamily: 'Roboto',
    height: 1,
    fontSize: 34,
    color: AppColors.green1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s32w500cWhite = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 32,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  // should use font Inter
  static const s30w600 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 30,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const s24w600 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    height: 1,
    fontVariations: [
      FontVariation('wght', 600),
    ],
    color: AppColors.gray2,
  );

  static const s24w400 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s24w400cGreen = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.green1,
  );

  static const s24w400cRed = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.red1,
  );

  static const s24w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const s22w400cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 22,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.grey2,
  );

  static const s22w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 22,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const s20w400 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s20w500 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s20w300cWhite = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20,
    height: 1,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s18w600cBlue2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    height: 1,
    color: AppColors.blue02,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const s18w600cShade09 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    height: 1,
    color: AppColors.shade09,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const s18w400cGray1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    height: 1,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s18w400cYellow1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.yellow1,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s18w400cRed1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.red1,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s18w400cBlue02 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.blue02,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s18w500cGray1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray1,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s18w500cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18,
    color: AppColors.gray2,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s16w400cGrey1 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey1,
    height: 1,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w400cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    height: 1,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w400cGrey3 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey3,
    height: 1,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w400cGrey4 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey4,
    fontSize: 16,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w400cGrey5 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey5,
    fontSize: 16,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s16w500cBlue2 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.blue02,
    fontSize: 16,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s16w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    color: AppColors.grey2,
    fontSize: 16,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s16w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16,
    height: 1,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s14w400 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s14w400cGrey1 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.grey1,
  );

  static const s14w400cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.grey2,
  );

  static const s14w500cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const s14w400cGrey4 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.grey4,
  );

  static const s14w400cGrey5 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.grey5,
  );

  static const s14w400cBlue2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
    color: AppColors.blue02,
  );

  static const s14w500 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s14w300 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s14w300cBlue2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    color: AppColors.blue02,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s14w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14,
    height: 1,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s14w300cGray5 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontSize: 14,
    color: AppColors.gray5,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s13w400cBlue05 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 13,
    height: 1,
    color: AppColors.blue05,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w500 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s12w500cGray5 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.gray5,
  );

  static const bodyB1 = TextStyle(
    fontFamily: _kFontFamily,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.grey2,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey3 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.grey3,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey4 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.grey4,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey6 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.grey6,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w400cGrey5fRoboto = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 1,
    color: AppColors.grey5,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s12w300cBlue2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.blue02,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s12w300cGray2 = TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12,
    height: 1,
    color: AppColors.gray2,
    fontVariations: [
      FontVariation('wght', 300),
    ],
  );

  static const s11w500fRoboto = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    height: 1,
    color: Colors.white,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const s11w400 = TextStyle(
    fontSize: 11,
    height: 1,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const s11w500 = TextStyle(
    fontSize: 11,
    height: 1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );
}
