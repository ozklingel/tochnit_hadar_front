import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  "תמיכה טכנית",
  "משתמשים",
  'בעיות נתונים',
  'אחר',
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
                value: list[i],
                child: Text(
                  list[i],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            )
          : menuItems.add(
              DropdownMenuItem<String>(
                value: list[i],
                child: Container(
                  width: double.maxFinite,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    top: 6, // adjust the way you like
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Text(
                    list[i],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selectedValue == null
              ? Colors.white
              : Colors.white10,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 0.80,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: DropdownButtonHideUnderline( 
  child:DropdownButton2<String>(
    
            isDense: true,
            hint: Text(
              " נושא",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: menuItems,
            selectedItemBuilder: (context) => list
                .map(
                  (text) => Text(
                    text,
                    style: const TextStyle(fontSize: 15),
                  ),
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
                // print(DropdownButtonExample.subject);
                selectedValue = value;
                // print(DropdownButtonExample.subject);
              });
            },
          )),
        ),
      ),
    );
  }
}
