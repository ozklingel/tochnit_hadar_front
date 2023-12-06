import 'package:flutter/material.dart';

import '../../../../services/routing/go_router_provider.dart';

void showFancyCustomDialog(BuildContext context) {
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
                child: Icon(
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
              child: Container(
                  child: const Image(
                image: AssetImage('assets/images/backhome.png'),
              )),
            ),
          ),
          Column(
            children: const [
              SizedBox(
                width: double.infinity,
                height: 30,
              ),
              const Image(
                image: AssetImage('assets/images/vi.png'),
              ),
              SizedBox(
                width: double.infinity,
                height: 5,
              ),
              Text(
                'פניתך נשלחה בהצלחה!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              Text(
                'נחזור אליך בהקדם',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                'תודה',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
