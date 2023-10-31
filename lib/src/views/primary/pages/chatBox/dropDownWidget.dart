import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  "תמיכה טכנית",
  "משתמשים",
  'בעיות נתונים',
  'אחר'
];

class DropdownButtonExample extends StatefulWidget {
  static String? subject;

  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late List<DropdownMenuItem<String>> menuItems = [];

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < list.length; i++) {
      //* on 1st index there will be no divider
      i == 0
          ? menuItems.add(
              DropdownMenuItem<String>(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      list[i],
                      style: TextStyle(fontSize: 15),
                    )),
                value: list[i],
              ),
            )
          : menuItems.add(
              DropdownMenuItem<String>(
                child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromRGBO(236, 242, 245, 1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          list[i],
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    )),
                value: list[i],
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: selectedValue == null
                  ? Colors.white
                  : Color.fromRGBO(236, 242, 245, 1),
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton2<String>(
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.expand_more_outlined,
                ),
                openMenuIcon: Icon(
                  Icons.expand_less_outlined,
                ),
                iconSize: 20,
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey,
              ),
              isDense: true,
              hint: Text(
                " נושא"!,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: menuItems,
              selectedItemBuilder: (context) => list
                  .map(
                    (text) => Text(text),
                  )
                  .toList(),
              value: selectedValue,
              buttonStyleData: const ButtonStyleData(
                height: 40,
                width: 400,
              ),
              onChanged: (String? value) {
                setState(() {
                  DropdownButtonExample.subject = value!;
                  print(DropdownButtonExample.subject);
                  selectedValue = value;
                  print(DropdownButtonExample.subject);
                });
              },
            )));
  }
}
