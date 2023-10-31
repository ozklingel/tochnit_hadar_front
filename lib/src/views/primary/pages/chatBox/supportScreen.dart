import 'package:flutter/material.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/chatBox/successDialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../services/notifications/toaster.dart';
import 'dropDownWidget.dart';
import 'errorDialog.dart';

class SupportScreen extends ConsumerWidget {
  SupportScreen({super.key});
  static late String subject = "";
  static late String contant = "";
  final TextEditingController _myController = TextEditingController();
  final sendButtonColor = 0xFF24517A;
  @override
  void initState() {
    _myController.text = '';
    _myController.addListener(() {});
  }

  @override
  void dispose() {
    _myController.dispose();
  }

  @override
  Widget build(BuildContext context, ref) {
    String subject;
    String contant;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        body: ListView(
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onTap: () => const HomeRouteData().go(context),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  child: const Text(
                    'פתיחת פנייה',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () => Toaster.unimplemented(),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: queryData.size.height - 100,
          padding: const EdgeInsets.all(32),
          /*1*/
          child: Column(
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'שליחת הודעה',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(
                'אנא השאירו את פנייתכם ונחזור אליכם ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Text(
                    "נושא",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              DropdownButtonExample(),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Text(
                    "תוכן הפניה",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: 250,
                  controller: _myController,
                  minLines: 7,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "error";
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: (_myController.text.isEmpty)
                          ? Color.fromRGBO(236, 242, 245, 1)
                          : Color(sendButtonColor),
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () async {
                      SupportScreen.contant = _myController.text;
                      print(SupportScreen.contant);
                      String result = "";
                      if (SupportScreen.contant != "" &&
                          SupportScreen.subject != null) {
                        result =
                            "success"; //await HttpService.ChatBoxUrl(SupportScreen.contant,SupportScreen.subject,context);
                      }
                      print(result);
                      if (result == "success") {
                        showFancyCustomDialog(context);
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Text(
                      "שליחת פנייה",
                      style: TextStyle(
                          color: _myController.text.isEmpty
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ))
            ],
          ),
        )
      ],
    ));
  }
}
