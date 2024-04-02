import 'package:flutter/material.dart';

import '../../../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialogAddGift(BuildContext context) {
  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 350.0,
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Align(
            // These values are based on trial & error method
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
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
          const Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2, bottom: 10, left: 2, right: 2),
                child: Image(
                  width: 150,
                  height: 160,
                  image: AssetImage('assets/images/mechiot_capayim.png'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 5,
              ),
              Text(
                'המתנה סומנה כנשלחה',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              Text(
                'ישר כוח!',
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
