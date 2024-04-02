import 'package:flutter/material.dart';

import '../../../../../../services/auth/auth_service.dart';
import '../../../../../../services/networking/http_service.dart';
import '../../../../../../services/routing/go_router_provider.dart';
import 'success_dialog.dart';


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
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () async {
                  
                        String result = await HttpService.deleteGiftAll(
                          auth.valueOrNull?.id,
                        );
                        if (result == "success") {
                          // print("in");
                          // ignore: use_build_context_synchronously
                          showFancyCustomDialog(context);
                        } else {
                          // print("in");

                          // ignore: use_build_context_synchronously
                        }
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
