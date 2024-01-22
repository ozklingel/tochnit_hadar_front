import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../services/auth/user_service.dart';
import '../../../../../services/networking/http_service.dart';
import '../../../../../services/routing/go_router_provider.dart';

class SettingPage extends StatefulHookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  bool t1 = false;
  bool t2 = false;
  bool t3 = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final user = ref.watch(userServiceProvider);

    var jsonData =
        await HttpService.getUserNotiSetting(user.valueOrNull!.phone);
    var u = jsonDecode(jsonData.body);
    //print("starttttt");
    //print(u);
    super.setState(() {
      t1 = !u["notifyStartWeek"];
      t2 = !u["notifyDayBefore"];
      t3 = !u["notifyMorning"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => {
            HttpService.setSetting(user.valueOrNull!.phone, t1, t2, t3),
            const NotificationRouteData().go(context),
          },
        ),
        title: const Text('ניהול התראות'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 60,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                'הגדרת זמני קבלת התראות על אירועים',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "בתחילת השבוע של האירוע ",
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: !t3
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                      ),
                      child: CupertinoSwitch(
                        value: t1,
                        activeColor: CupertinoColors.white,
                        trackColor: CupertinoColors.white,
                        thumbColor: !t1
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                        onChanged: (v) => setState(() {
                          debugPrint(t1.toString());
                          t1 = v;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "יום לפני האירוע",
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: !t2
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                      ),
                      child: CupertinoSwitch(
                        value: t2,
                        activeColor: CupertinoColors.white,
                        trackColor: CupertinoColors.white,
                        thumbColor: !t2
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                        onChanged: (v) => setState(() {
                          t2 = v;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        " ביום האירוע",
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: !t3
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                      ),
                      child: CupertinoSwitch(
                        value: t3,
                        activeColor: CupertinoColors.white,
                        trackColor: CupertinoColors.white,
                        thumbColor: !t3
                            ? Colors.blue.shade700
                            : CupertinoColors.inactiveGray,
                        onChanged: (v) => setState(() {
                          t3 = v;
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
