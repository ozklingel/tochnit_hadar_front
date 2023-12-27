import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
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
    late final context =
        ref.read(goRouterProvider).configuration.navigatorKey.currentContext!;

    return {
      const SingleActivator(
        LogicalKeyboardKey.keyA,
        alt: true,
      ): () async => await const OnboardingRouteData().push(context),
      const SingleActivator(
        LogicalKeyboardKey.keyT,
        alt: true,
      ): () async => await const NewTaskRouteData().push(context),
      const SingleActivator(
        LogicalKeyboardKey.keyE,
        alt: true,
      ): () async => await const ReportNewRouteData().push(context),
      const SingleActivator(
        LogicalKeyboardKey.keyC,
        alt: true,
      ): () async => await const ChartsRouteData().push(context),
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): () => ref.read(goRouterProvider).canPop()
          ? ref.read(goRouterProvider).pop()
          : null,
      const SingleActivator(
        LogicalKeyboardKey.keyI,
        alt: true,
      ): () async => await const InstitutionsRouteData().push(context),
      const SingleActivator(
        LogicalKeyboardKey.equal,
        alt: true,
      ): () async {
        // only needed for now on 23/12/27
        if (kDebugMode) {
          await ref.read(storageProvider).requireValue.setString(
                Consts.userPhoneKey,
                'kDebugPhone',
              );

          await ref.read(storageProvider).requireValue.setString(
                Consts.accessTokenKey,
                'kDebugAccessToken',
              );

          await ref.read(storageProvider).requireValue.setBool(
                Consts.firstOnboardingKey,
                false,
              );
          Logger().d('RESET sharedPrefs values');
        }
      },
      const SingleActivator(
        LogicalKeyboardKey.minus,
        alt: true,
      ): () async {
        // only needed for now on 23/12/27
        if (kDebugMode) {
          await ref.read(storageProvider).requireValue.setString(
                Consts.userPhoneKey,
                '',
              );

          await ref.read(storageProvider).requireValue.setString(
                Consts.accessTokenKey,
                '',
              );

          await ref.read(storageProvider).requireValue.remove(
                Consts.firstOnboardingKey,
              );
          Logger().d('RESET sharedPrefs values');
        }
      },
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
