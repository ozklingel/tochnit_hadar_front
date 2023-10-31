import 'package:flutter/material.dart';

void showFancyCustomDialog(BuildContext context) {
  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 350.0,
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Align(
            // These values are based on trial & error method
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  icon: Icon(
                    // <-- Icon
                    Icons.hourglass_empty,
                    color: Colors.white,
                  ),
                  label: Text(
                    'חזרה לדף הבית    ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ), // <-- Text
                ),
              ),
            ),
          ),
          Column(
            children: const [
              SizedBox(
                width: double.infinity,
                height: 30,
              ),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/vi.png'),
              ),
              SizedBox(
                width: double.infinity,
                height: 5,
              ),
              Text(
                '!פניתך נשלחה בהצלחה',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              Text(
                'נחזור אליך בהקדם',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 10,
              ),
              Text(
                'תודה',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
