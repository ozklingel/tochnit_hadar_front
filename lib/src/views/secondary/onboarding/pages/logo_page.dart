import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';

class OnboardingPage0Logo extends HookWidget {
  const OnboardingPage0Logo({
    super.key,
    required this.onLoaded,
  });

  final VoidCallback onLoaded;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        Timer.periodic(const Duration(seconds: 3), (timer) {
          timer.cancel();
          onLoaded();
        });
        return null;
      },
      [],
    );

    return Center(
      child: Assets.images.logo.image(),
    );
  }
}
