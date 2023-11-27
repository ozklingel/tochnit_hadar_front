import 'package:flutter/cupertino.dart';
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
                    HttpService.setSetting("549247616", t1, t2, t3),
                    const notificationRouteData().go(context),
                  }),
          title: const Text('ניהול התראות'),
        ),
        body: Column(
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
                padding: EdgeInsets.only(top: 20, left: 24, right: 24),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "בתחילת השבוע של האירוע ",
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: t3
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                          ),
                          child: CupertinoSwitch(
                            value: t1,
                            activeColor: CupertinoColors.white,
                            trackColor: CupertinoColors.white,
                            thumbColor: t3
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                            onChanged: (v) => setState(() {
                              t3 = v;
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "יום לפני האירוע",
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: t2
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                          ),
                          child: CupertinoSwitch(
                            value: t3,
                            activeColor: CupertinoColors.white,
                            trackColor: CupertinoColors.white,
                            thumbColor: t3
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                            onChanged: (v) => setState(() {
                              t3 = v;
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            " ביום האירוע",
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: t3
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                          ),
                          child: CupertinoSwitch(
                            value: t3,
                            activeColor: CupertinoColors.white,
                            trackColor: CupertinoColors.white,
                            thumbColor: t3
                                ? Colors.blue.shade700
                                : CupertinoColors.inactiveGray,
                            onChanged: (v) => setState(() {
                              t3 = v;
                            }),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
