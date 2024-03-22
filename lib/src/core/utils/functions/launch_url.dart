// https://stackoverflow.com/questions/63312503/i-want-to-launch-whatsapp-application-from-my-flutter-application
// https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
// https://stackoverflow.com/questions/45523370/how-to-make-a-phone-call-from-a-flutter-app

import 'dart:io';


import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

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
