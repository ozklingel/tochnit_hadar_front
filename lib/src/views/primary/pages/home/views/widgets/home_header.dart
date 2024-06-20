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

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            child: currentTime.hour > 5 && currentTime.hour < 12
                ? Assets.animations.goodMorningV02.image()
                : currentTime.hour < 21
                    ? Assets.animations.goodAfternoonV02.image(
                        fit: BoxFit.contain,
                      )
                    : Assets.animations.goodEveningV02B.image(),
          ),
          Positioned(
            right: 48,
            top: 40,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: currentTime.hour > 5 && currentTime.hour < 12
                        ? 'בוקר טוב'
                        : currentTime.hour < 21
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
