import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
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

import 'src/services/notifications/local_notification_service .dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
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
          kDebugMode
              ? CallbackShortcuts(
                  bindings: _shortcuts(ref),
                  child: child!,
                )
              : child,
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
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
    }

  await LocalNotifications.init();
      LocalNotifications.showSimpleNotification(
        title: "Simple Notification",
        body: "This is a simple notification",
        payload: "This is simple data");

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                String? device = data["device"];
                DateTime? date = DateTime.tryParse(data["current_date"]);
                return Column(
                  children: [
                    Text(device ?? 'Unknown'),
                    Text(date.toString()),
                  ],
                );
              },
            ),
            ElevatedButton(
              child: const Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
            ),
            ElevatedButton(
              child: const Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();
                if (isRunning) {
                  service.invoke("stopService");
                } else {
                  service.startService();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                }
                setState(() {});
              },
            ),
            const Expanded(
              child: LogView(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late final Timer timer;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      logs = sp.getStringList('log') ?? [];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
        return Text(log);
      },
    );
  }
}