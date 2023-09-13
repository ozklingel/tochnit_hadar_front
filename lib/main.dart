import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: HadarProgram(),
    ),
  );
}

class HadarProgram extends ConsumerWidget {
  const HadarProgram({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: Consts.appTitle,
      theme: appThemeLight,
      builder: BotToastInit(),
    );
  }
}
