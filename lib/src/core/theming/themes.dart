import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

ThemeData get appThemeLight {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'rubik',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyles.s24w500cGrey2,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue03,
        textStyle: TextStyles.s14w400,
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.blue02,
      dividerColor: Colors.transparent,
      labelStyle: TextStyles.s14w400.copyWith(
        color: AppColors.gray2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    searchBarTheme: SearchBarThemeData(
      hintStyle: MaterialStateProperty.all(
        TextStyles.s16w400cGrey2.copyWith(
          color: AppColors.gray5,
        ),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyles.s16w400cGrey2.copyWith(
          color: AppColors.gray2,
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      elevation: 10,
      surfaceTintColor: Colors.white,
      labelTextStyle: MaterialStateProperty.all(
        TextStyles.s16w400cGrey2.copyWith(
          color: AppColors.gray2,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      iconTheme: const IconThemeData(
        color: AppColors.grey1,
      ),
      labelStyle: TextStyles.s14w500.copyWith(
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
      hintStyle: TextStyles.s16w400cGrey5,
      errorStyle: TextStyles.s12w500,
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
      titleMedium: TextStyles.s20w500,
      bodyMedium: TextStyles.s14w400,
      displayMedium: TextStyles.s14w500,
      displaySmall: TextStyles.s12w500,
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
