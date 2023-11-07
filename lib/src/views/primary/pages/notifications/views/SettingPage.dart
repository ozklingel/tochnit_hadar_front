import 'package:flutter/material.dart';

import '../../../../../services/routing/go_router_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool t1 = false;
  bool t2 = false;
  bool t3 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [],
                  ),
                  Row(
                    children: [
                      Text(
                        ' ניהול התראות',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onTap: () => const notificationRouteData().go(context),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Column(
        children: <Widget>[
          Container(
            height: 60,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Text(
                'הגדרת זמני קבלת התראות על אירועים',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 19,
                    color: Colors.black),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    //switch at left side of label
                    value: t1,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      setState(() {
                        t1 = value; //update value when sitch changed
                      });
                    },
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "בתחילת השבוע של האירוע",
                      ),
                    ),
                  ),
                  SwitchListTile(
                    //switch at left side of label
                    value: t2,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      setState(() {
                        t2 = value; //update value when sitch changed
                      });
                    },
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "יום לפני האירוע",
                      ),
                    ),
                  ),
                  SwitchListTile(
                    //switch at left side of label
                    value: t3,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      setState(() {
                        t3 = value; //update value when sitch changed
                      });
                    },
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "ביום האירוע",
                      ),
                    ),
                  ),
                ],
              ))
        ],
      )
    ])));
  }
}
