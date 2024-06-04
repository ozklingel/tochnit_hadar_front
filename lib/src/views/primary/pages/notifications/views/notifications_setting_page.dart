import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../../models/auth/auth.dto.dart';
import '../../../../../services/auth/auth_service.dart';
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
    final auth = ref.watch(authServiceProvider);

    final jsonData =
        await HttpService.getUserNotiSetting(auth.valueOrNull!.phone);
    final u = jsonDecode(jsonData.body);

    // Logger().d(u);

    super.setState(() {
      t1 = !u["notifyStartWeek"];
      t2 = !u["notifyDayBefore"];
      t3 = !u["notifyMorning"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => {
            HttpService.setSetting(auth.valueOrNull!.phone, !t1, !t2, !t3),
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
                  fontWeight: FontWeight.w800,
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
                ...[
                  Container(
                    height: 60,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 0),
                      child: Text(
                        'משימות מתוזמנות',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "בתחילת השבוע של משימה ",
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
                            Logger().d(t1.toString());
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
                          "יום לפני משימה",
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
                          " ביום משימה",
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
                if (auth.valueOrNull?.role == UserRole.ahraiTohnit) ...[
                  Container(
                    height: 60,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 0),
                      child: Text(
                        'תזכורת סבב מוסד',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
                            Logger().d(t1.toString());
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
                if (auth.valueOrNull?.role == UserRole.melave ||
                    auth.valueOrNull?.role == UserRole.rakazEshkol ||
                    auth.valueOrNull?.role == UserRole.rakazMosad) ...[
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
                            Logger().d(t1.toString());
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
