import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/primary/pages/chatBox/successDialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../services/networking/HttpService.dart';
import '../../../../services/routing/go_router_provider.dart';
import 'dropDownWidget.dart';
import 'errorDialog.dart';

class SupportScreen extends ConsumerWidget {
  SupportScreen({super.key});
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => const HomeRouteData().go(context),
            ),
            title: Text("פתיחת פניה")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32),
              /*1*/
              child: Column(
                children: [
                  /*2*/
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'שליחת הודעה',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    height: 20,
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
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: _myController,
                      minLines: 7,
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
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
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Text(''),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                height: 50,
                width: 20,
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
                    print(DropdownButtonExample.subject);

                    String result = "";
                    if (SupportScreen.contant != "" &&
                        DropdownButtonExample.subject != null) {
                      result = await HttpService.ChatBoxUrl(
                          SupportScreen.contant,
                          DropdownButtonExample.subject,
                          context);
                    }
                    print(result);
                    print(result);

                    if (result == "success") {
                      print("in");
                      showFancyCustomDialog(context);
                    } else {
                      print("in");

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
                )),
          ],
        ));
  }
}
