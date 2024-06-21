import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
    final currentTime = DateTime.now();
    final isGoodSabbath = currentTime.weekday == 5;
    final isGoodWeek = currentTime.weekday == 6 ||
        (currentTime.weekday == 7 && currentTime.hour < 5);
    final isMorning = currentTime.hour > 5 && currentTime.hour < 12;
    final isAfternoon = currentTime.hour < 21;

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            child: FittedBox(
              fit: BoxFit.contain,
              child: isGoodSabbath
                  ? Assets.animations.goodShabbatV01.image()
                  : isGoodWeek
                      ? Assets.animations.goodWeekV01.image()
                      : isMorning
                          ? Assets.animations.goodMorningV02.image()
                          : isAfternoon
                              ? Assets.animations.goodAfternoonV02.image()
                              : Assets.animations.goodEveningV02B.image(),
            ),
          ),
          Positioned(
            right: 48,
            top: 40,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: isGoodSabbath
                        ? 'שבת שלום'
                        : isGoodWeek
                            ? 'שבוע טוב'
                            : isMorning
                                ? 'בוקר טוב'
                                : isAfternoon
                                    ? 'צהריים טובים'
                                    : 'ערב טוב',
                    style: TextStyles.s20w300cWhite,
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    text: auth.valueOrNull?.fullName,
                    style: TextStyles.s32w500cWhite,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
