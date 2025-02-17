import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/networking/http_service.dart';
import '../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialog(BuildContext context, phone, contant, subject) {
  bool wasPressed = false;
  Timer(const Duration(seconds: 3), () async {
    if (!wasPressed) {
      await HttpService.chatBoxUrl(
        phone,
        contant,
        subject,
        context,
      );
      if (context.mounted) {
        const HomeRouteData().go(context);
      }
    }
  });

  Size size = MediaQuery.of(context).size;

  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: size.height * 2 / 3,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              // These values are based on trial & error method
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  wasPressed = true;
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: () {
                const HomeRouteData().go(context);
              },
              child: const SizedBox(
                child: Image(
                  image: AssetImage('assets/images/backhome.png'),
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                width: double.infinity,
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                  bottom: 10,
                  left: 2,
                  right: 2,
                ),
                child: Image(
                  width: size.width * 2 / 3,
                  height: size.height * 4 / 10,
                  image: const AssetImage('assets/images/success-smile.png'),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 5,
              ),
              const Text(
                'פניתך נשלחה בהצלחה!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20,
              ),
              const Text(
                'נחזור אליך בהקדם',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const Text(
                'תודה',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
