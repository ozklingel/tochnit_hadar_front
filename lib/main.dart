import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  Paint.enableDithering = true;

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
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: Consts.appTitle,
      theme: appThemeLight,
      scrollBehavior: _scrollBehavior,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Consts.defaultLocale,
      supportedLocales: const [
        Consts.defaultLocale,
      ],
      builder: (context, child) => BotToastInit()(
        context,
        CallbackShortcuts(
          bindings: _shortcuts(ref),
          child: child!,
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts(WidgetRef ref) {
    return {
      const SingleActivator(
        LogicalKeyboardKey.keyA,
        alt: true,
      ): () => ref.read(goRouterProvider).push(OnboardingScreen.routeName),
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): () => ref.read(goRouterProvider).canPop()
          ? ref.read(goRouterProvider).pop()
          : null,
    };
  }
}

final _scrollBehavior = const MaterialScrollBehavior().copyWith(
  dragDevices: {
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.touch,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  },
);
