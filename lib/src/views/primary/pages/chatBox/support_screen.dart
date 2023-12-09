import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/primary/pages/chatBox/success_dialog.dart';

import '../../../../services/networking/http_service.dart';
import '../../../../services/routing/go_router_provider.dart';
import 'drop_down_widget.dart';
import 'error_dialog.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  static String contant = "";

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _myController = TextEditingController();

  final sendButtonColor = 0xFF24517A;

  @override
  void initState() {
    super.initState();
    _myController.text = '';
    _myController.addListener(() {});
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => const HomeRouteData().go(context),
        ),
        title: const Text("פתיחת פניה"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
            color: Colors.white,
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
                const Text(
                  'אנא השאירו את פנייתכם ונחזור אליכם ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Text(
                      "נושא",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const DropdownButtonExample(),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                    Text(
                      "תוכן הפניה",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.80,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    controller: _myController,
                    minLines: 7,
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    decoration: const InputDecoration(
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
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
            height: 60,
            width: 348,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: (_myController.text.isEmpty)
                    ? const Color.fromRGBO(236, 242, 245, 1)
                    : Color(sendButtonColor),
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                SupportScreen.contant = _myController.text;
                // print(SupportScreen.contant);
                // print(DropdownButtonExample.subject);

                String result = "";
                if (SupportScreen.contant != "" &&
                    DropdownButtonExample.subject != null) {
                  result = await HttpService.chatBoxUrl(
                    SupportScreen.contant,
                    DropdownButtonExample.subject,
                    context,
                  );
                }
                // print(result);
                // print(result);

                if (!mounted) {
                  return;
                }

                if (result == "success") {
                  // print("in");
                  showFancyCustomDialog(context);
                } else {
                  // print("in");

                  showAlertDialog(context);
                }
              },
              child: Text(
                "שליחת פנייה",
                style: TextStyle(
                  color:
                      _myController.text.isEmpty ? Colors.grey : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
