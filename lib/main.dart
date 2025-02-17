import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/themes.dart';
import 'package:hadar_program/src/core/utils/functions/outbound_notification.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart';

Future<void> main() async {
  // Check if the platform is not web and is either Android or iOS
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    // TODO(noga-dev): budget permitting this should have an init loader
    // Initialize notifications service only for Android or iOS
    await initializeNotificationsService();
  }

  await SentryFlutter.init(
    (options) {
      // options.debug = kDebugMode;
      options.attachScreenshot = kReleaseMode;
      options.dsn =
          'https://9648d7069cc6243a7f1e8e366a6cff42@o4506474413752320.ingest.sentry.io/4506474416242688';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
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

    return RequestsInspector(
      enabled: kDebugMode,
      hideInspectorBanner: true,
      navigatorKey: router.routerDelegate.navigatorKey,
      showInspectorOn: ShowInspectorOn.Shaking,
      child: _EagerInitialization(
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
            kDebugMode
                ? CallbackShortcuts(
                    bindings: _shortcuts(ref),
                    child: child!,
                  )
                : child,
          ),
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts(WidgetRef ref) {
    final router = ref.read(goRouterServiceProvider);
    late final context = router.configuration.navigatorKey.currentContext!;

    return {
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): () async {
        if (router.canPop()) {
          router.pop();
        }
      },
      const SingleActivator(
        LogicalKeyboardKey.keyH,
        alt: true,
      ): () async {
        InspectorController().showInspector();
      },
      const SingleActivator(
        LogicalKeyboardKey.numpad1,
        alt: true,
      ): () async =>
          ref.read(authServiceProvider.notifier).overrideRole(UserRole.melave),
      const SingleActivator(
        LogicalKeyboardKey.numpad2,
        alt: true,
      ): () async => ref
          .read(authServiceProvider.notifier)
          .overrideRole(UserRole.rakazMosad),
      const SingleActivator(
        LogicalKeyboardKey.numpad3,
        alt: true,
      ): () async => ref
          .read(authServiceProvider.notifier)
          .overrideRole(UserRole.rakazEshkol),
      const SingleActivator(
        LogicalKeyboardKey.numpad4,
        alt: true,
      ): () async => ref
          .read(authServiceProvider.notifier)
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
      ): () async => await const ReportNewRouteData(
            initRecipients: [],
          ).push(context),
      const SingleActivator(
        LogicalKeyboardKey.keyC,
        alt: true,
      ): () async => await const ChartsRouteData().push(context),
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
          await ref.read(storageServiceProvider).requireValue.setString(
                Consts.userPhoneKey,
                'kDebugPhone',
              );

          await ref.read(storageServiceProvider).requireValue.setString(
                Consts.accessTokenKey,
                'kDebugAccessToken',
              );

          await ref.read(storageServiceProvider).requireValue.setBool(
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
          await ref.read(storageServiceProvider).requireValue.setString(
                Consts.userPhoneKey,
                '',
              );

          await ref.read(storageServiceProvider).requireValue.setString(
                Consts.accessTokenKey,
                '',
              );

          await ref.read(storageServiceProvider).requireValue.remove(
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
    final result = ref.watch(storageServiceProvider);

    if (result.isLoading) {
      return const CircularProgressIndicator();
    } else if (result.hasError) {
      return const Text('😔');
    }

    return child;
  }
}



// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch



  // bring to foreground


