import 'package:flutter/material.dart';


import '../../../../../../services/routing/go_router_provider.dart';


void showWarnningCustomDialog(BuildContext context,ref,auth) {

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
           
              Text(
                '  מחיקת קודים',
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
