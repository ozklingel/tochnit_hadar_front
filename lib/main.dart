import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setLocaleMessages(
    Consts.defaultLocale.languageCode,
    HeMessages(),
  );

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

    return _EagerInitialization(
      child: MaterialApp.router(
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
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts(WidgetRef ref) {
    return {
      const SingleActivator(
        LogicalKeyboardKey.keyA,
        alt: true,
      ): () => const OnboardingRouteData().push(
            ref
                .read(goRouterProvider)
                .configuration
                .navigatorKey
                .currentContext!,
          ),
      const SingleActivator(
        LogicalKeyboardKey.keyT,
        alt: true,
      ): () => const NewTaskRouteData().push(
            ref
                .read(goRouterProvider)
                .configuration
                .navigatorKey
                .currentContext!,
          ),
      const SingleActivator(
        LogicalKeyboardKey.keyE,
        alt: true,
      ): () => const ReportNewRouteData().push(
            ref
                .read(goRouterProvider)
                .configuration
                .navigatorKey
                .currentContext!,
          ),
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): () => ref.read(goRouterProvider).canPop()
          ? ref.read(goRouterProvider).pop()
          : null,
      const SingleActivator(
        LogicalKeyboardKey.keyI,
        alt: true,
      ): () => const InstitutionsRouteData().push(
            ref
                .read(goRouterProvider)
                .configuration
                .navigatorKey
                .currentContext!,
          ),
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

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(storageProvider);

    if (result.isLoading) {
      return const CircularProgressIndicator();
    } else if (result.hasError) {
      return const Text('😔');
    }

    return child;
  }
}
