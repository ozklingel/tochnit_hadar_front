import 'package:flutter/material.dart';

import '../../../../../services/networking/HttpService.dart';
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
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => {
                    HttpService.setSetting("1", t1, t2, t3),
                    const HomeRouteData().go(context),
                  }),
          title: const Text('ניהול התראות'),
        ),
        body: Column(children: [
          Column(
            children: <Widget>[
              Container(
                height: 60,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'הגדרת זמני קבלת התראות על אירועים',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
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
                        activeColor: Colors.blue[700],

                        value: t1,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (bool value) {
                          setState(() {
                            t1 = value;
                            print(t1); //update value when sitch changed
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
                        activeColor: Colors.blue[700],

                        //switch at left side of label
                        value: t2,
                        controlAffinity: ListTileControlAffinity.trailing,
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
                        activeColor: Colors.blue[700],

                        //switch at left side of label
                        value: t3,
                        controlAffinity: ListTileControlAffinity.trailing,
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
        ]));
  }
}
