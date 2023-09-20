import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

abstract class Toaster {
  static void unimplemented() => BotToast.showText(
        text: 'Unimplemented',
        align: const Alignment(0.9, -0.9),
        contentColor: AppColors.warning500,
        contentPadding: const EdgeInsets.all(16),
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontVariations: [FontVariation('wght', 700)],
          color: Colors.black,
        ),
      );

  static void error(Object? message) => BotToast.showText(
        text: message?.toString() ?? '???',
        align: const Alignment(0.9, -0.9),
        contentColor: AppColors.error500,
        contentPadding: const EdgeInsets.all(16),
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontVariations: [FontVariation('wght', 700)],
          color: Colors.black,
        ),
      );

  static void show(String message) => BotToast.showText(text: message);
}
