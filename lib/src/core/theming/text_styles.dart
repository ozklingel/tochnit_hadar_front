import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

abstract class TextStyles {
  static const bodyB4 = TextStyle(
    fontFamily: 'rubik',
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB4Bold = TextStyle(
    fontFamily: 'rubik',
    fontSize: 24,
    fontVariations: [
      FontVariation('wght', 500),
    ],
    color: AppColors.grey2,
  );

  static const bodyB41 = TextStyle(
    fontFamily: 'rubik',
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB41Bold = TextStyle(
    fontFamily: 'rubik',
    fontSize: 20,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const messageTitle = TextStyle(
    fontFamily: 'rubik',
    fontSize: 18,
    color: AppColors.shade09,
    fontVariations: [
      FontVariation('wght', 600),
    ],
  );

  static const reportName = TextStyle(
    fontFamily: 'rubik',
    fontSize: 18,
    color: AppColors.gray1,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB3 = TextStyle(
    fontFamily: 'rubik',
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB3Bold = TextStyle(
    fontFamily: 'rubik',
    color: AppColors.grey2,
    fontSize: 16,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB2 = TextStyle(
    fontFamily: 'rubik',
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 400),
    ],
  );

  static const bodyB2Bold = TextStyle(
    fontFamily: 'rubik',
    fontSize: 14,
    fontVariations: [
      FontVariation('wght', 500),
    ],
  );

  static const bodyB1Bold = TextStyle(
    fontFamily: 'rubik',
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
}
