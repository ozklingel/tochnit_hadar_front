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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: SizedBox(
          height: 140,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5083bb),
                  Color(0xFF34547c),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width * -0.06,
                  right: MediaQuery.of(context).size.width * -0.06,
                  child: Assets.images.homePageHeader.svg(
                    fit: BoxFit.cover,
                    // colorFilter: const ColorFilter.mode(
                    //   Colors.red,
                    //   BlendMode.colorBurn,
                    // ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: DateTime.now().hour > 3 &&
                                      DateTime.now().hour < 11
                                  ? 'בוקר טוב'
                                  : DateTime.now().hour < 21
                                      ? 'ערב טוב'
                                      : 'לילה טוב',
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
