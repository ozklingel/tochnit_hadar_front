import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.debug = kDebugMode;
      options.attachScreenshot = kReleaseMode;
      // or define SENTRY_DSN via Dart environment variable (--dart-define)
      options.dsn =
          'https://9648d7069cc6243a7f1e8e366a6cff42@o4506474413752320.ingest.sentry.io/4506474416242688';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      WidgetsFlutterBinding.ensureInitialized();

      setLocaleMessages(
        Consts.defaultLocale.languageCode,
        HeMessages(),
      );

      return runApp(
        ProviderScope(
          child: SentryScreenshotWidget(
            child: const HadarProgram(),
          ),
        ),
      );
    },
  );
}

class HadarProgram extends ConsumerWidget {
  const HadarProgram({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(goRouterServiceProvider);

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
    late final context = ref
        .read(goRouterServiceProvider)
        .configuration
        .navigatorKey
        .currentContext!;

    return {
      const SingleActivator(
        LogicalKeyboardKey.numpad1,
        alt: true,
      ): () async =>
          ref.read(userServiceProvider.notifier).overrideRole(UserRole.melave),
      const SingleActivator(
        LogicalKeyboardKey.numpad2,
        alt: true,
      ): () async => ref
          .read(userServiceProvider.notifier)
          .overrideRole(UserRole.rakazMosad),
      const SingleActivator(
        LogicalKeyboardKey.numpad3,
        alt: true,
      ): () async => ref
          .read(userServiceProvider.notifier)
          .overrideRole(UserRole.rakazEshkol),
      const SingleActivator(
        LogicalKeyboardKey.numpad4,
        alt: true,
      ): () async => ref
          .read(userServiceProvider.notifier)
          .overrideRole(UserRole.ahraiTohnit),
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
      ): () {
        if (ref.read(goRouterServiceProvider).canPop()) {
          ref.read(goRouterServiceProvider).pop();
        }
      },
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
                Consts.isFirstOnboardingKey,
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
                Consts.isFirstOnboardingKey,
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
