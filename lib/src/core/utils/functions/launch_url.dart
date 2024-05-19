// https://stackoverflow.com/questions/63312503/i-want-to-launch-whatsapp-application-from-my-flutter-application
// https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
// https://stackoverflow.com/questions/45523370/how-to-make-a-phone-call-from-a-flutter-app

import 'dart:io';

import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUri(Uri uri, String platform) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    Toaster.error('Some $platform error occurred. Please try again!');
  }
}

void launchWaze({
  required String lat,
  required String lng,
}) async {
  final uri =
      Uri.parse('https://www.waze.com/ul?ll=$lat%2C-$lng&navigate=yes&zoom=17');
  await _launchUri(uri, 'Waze');
}

void launchGoogleMaps({
  required String lat,
  required String lng,
}) async {
  final uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
  await _launchUri(uri, 'Google Maps');
}

void launchWhatsapp({
  required String phone,
  String text = '',
}) async {
  final whatsapp = '972$phone'; //+972xx enter like this
  final whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
  final whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";

  _launchUri(
    Uri.parse(Platform.isIOS ? whatsappURLIos : whatsappURlAndroid),
    'Whatsapp',
  );
}

void launchSms({
  required List<String> phone,
  String bodyText = '',
}) async {
  final uri = Uri.parse(
    'sms:${phone.map((e) => '+972$e').join(',')}?body=${Uri.encodeComponent(bodyText)}',
  );
  _launchUri(uri, 'SMS');
}

void launchEmail({
  required String email,
  body = '',
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=Hello&body=$body',
  );
  _launchUri(uri, 'email');
}

void launchCall({
  required phone,
}) async {
  final url = Uri.parse('tel:+972$phone');
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {
    Toaster.error('Some phone error occurred. Please try again!');
  }
}

Future<void> launchGiftStore() async =>
    _launchUri(Uri.parse('https://www.caveret.org/'), 'Caveret');
