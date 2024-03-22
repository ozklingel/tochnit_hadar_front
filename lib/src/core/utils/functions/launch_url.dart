// https://stackoverflow.com/questions/63312503/i-want-to-launch-whatsapp-application-from-my-flutter-application
// https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
// https://stackoverflow.com/questions/45523370/how-to-make-a-phone-call-from-a-flutter-app

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/networking/http_service.dart';
import '../../../services/notifications/local_notification_service.dart';

void launchWaze({
  required String lat,
  required String lng,
}) async {
  final url = 'https://www.waze.com/ul?ll=$lat%2C-$lng&navigate=yes&zoom=17';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    Toaster.error('Some waze occurred. Please try again!');
  }
}

void launchGoogleMaps({
  required String lat,
  required String lng,
}) async {
  final url = 'https://www.google.com/maps?q=$lat,$lng';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    Toaster.error('Some google maps occurred. Please try again!');
  }
}

void launchWhatsapp({
  required String phone,
  String text = '',
}) async {
  final whatsapp = '972$phone'; //+92xx enter like this
  final whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
  final whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";

  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
      await launchUrl(Uri.parse(whatsappURLIos));
    } else {
      Toaster.error('Some whatsapp error occurred. Please try again!');
    }
  } else {
    // android , web
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      Toaster.error('Some whatsapp error occurred. Please try again!');
    }
  }
}

void launchSms({
  required phone,
  String bodyText = '',
}) async {
  final uri = Uri.parse('sms:$phone?body=${Uri.encodeComponent(bodyText)}');

  try {
    if (!await canLaunchUrl(uri)) {
      throw Exception('cannot launch sms uri');
    }

    if (Platform.isAndroid) {
      await launchUrl(uri);
    } else if (Platform.isIOS) {
      await launchUrl(uri);
    }
  } catch (e) {
    Toaster.error(e);
  }
}

void launchEmail({
  required String email,
  body = '',
}) async {
  final url = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=Hello&body=$body',
  );
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {
    Toaster.error('Some email error occurred. Please try again!');
  }
}

void launchCall({
  required phone,
}) async {
  final url = Uri.parse('tel:972$phone');
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {
    Toaster.error('Some phone error occurred. Please try again!');
  }
}


Future<void> initializeNotificationsService() async {
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
  Timer.periodic(const Duration(seconds: 100), (timer) async {
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
    var userid="549247616";
    var outboun_notifications= HttpService.getUserAlert(userid);
    await LocalNotifications.init();
    LocalNotifications.showSimpleNotification(
      title: outboun_notifications.toString(),
      body: "This is a Oz notification",
      payload: "This is Oz data",
    );

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

