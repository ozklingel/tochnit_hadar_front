import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../models/notification/noti.dart';
import '../../../../../services/networking/HttpService.dart';
import '../../../../../services/routing/go_router_provider.dart';
import 'emptyScreen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Noti> notis = [];

  Future<List<Noti>> _getNoti() async {
    print("access API");
    var jsonData = await HttpService.getUserNoti("+972549247616", context);
    notis.clear();
    print(jsonData.body);
    for (var u in jsonDecode(jsonData.body)) {
      Noti noti = Noti(
        u["id"].toString(),
        u["apprenticeId"].toString(),
        u["event"].toString(),
        u["date"].toString(),
        u["daysfromnow"].toString(),
        u["title"].toString(),
        u["allreadyread"].toString(),
        u["numOfLinesDisplay"].toString(),
      );
      notis.add(noti);
    }
    return notis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => const HomeRouteData().go(context),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () => const NotificationSettingRouteData().go(context),
          )
        ],
        title: const Text('התראות'),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(3.0),
        child: FutureBuilder(
          future: _getNoti(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data.length);
            if (snapshot.data == null || snapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: emptyScreen(),
                ),
              );
            } else {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), //<--here

                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    String now =
                        DateFormat("dd.MM.yyyy").format(DateTime.now());
                    return ListTile(
                      tileColor: (snapshot.data[index].allreadyread
                                  .replaceAll(' ', '') ==
                              "false")
                          ? Colors.blue[50] //fromRGBO(244, 248, 251, 1)
                          : Colors.white,
                      trailing: (snapshot.data[index].numOfLinesDisplay == "3")
                          ? Text(" לפני " +
                              snapshot.data[index].timeFromNow +
                              " ימים ")
                          : Text(now),
                      title: (snapshot.data[index].numOfLinesDisplay == "3")
                          ? Text(snapshot.data[index].event,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold))
                          : Text("הגיע הזמן ל" + snapshot.data[index].event,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: (snapshot.data[index].numOfLinesDisplay == "3")
                          ? Text(
                              "בתאריך " +
                                  snapshot.data[index].date +
                                  "\n" +
                                  snapshot.data[index].details +
                                  " ל" +
                                  snapshot.data[index].apprenticeId,
                              textAlign: TextAlign.right)
                          : Text("עברו " +
                              snapshot.data[index].timeFromNow +
                              "  יום מה" +
                              snapshot.data[index].event +
                              " של " +
                              snapshot.data[index].apprenticeId),
                      onTap: () {
                        if (snapshot.data[index].allreadyread
                                .replaceAll(' ', '') ==
                            "false") {
                          HttpService.sendAllreadyread(snapshot.data[index].id);
                          setState(
                              () => snapshot.data[index].allreadyread = "true");
                          // print(snapshot.data[index].id + " was read");
                        }
                      },
                    );
                  });
            }
          },
        ),
      )),
    );
  }
}
