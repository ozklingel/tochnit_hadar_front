import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Stack(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5083bb),
                    Color(0xFF34547c),
                  ],
                ),
              ),
              child: Assets.images.homePageHeader.svg(
                height: 140,
                width: 320,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'בוקר טוב',
                          style: TextStyles.s20w300cWhite,
                        ),
                        const TextSpan(text: '\n\n'),
                        TextSpan(
                          text: user.valueOrNull?.fullName,
                          style: TextStyles.s32w500cWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
