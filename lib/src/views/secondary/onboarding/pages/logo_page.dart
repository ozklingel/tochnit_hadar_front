import 'package:flutter/material.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';

class OnboardingLogoPage extends StatelessWidget {
  const OnboardingLogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Assets.images.logo.image(),
    );
  }
}
