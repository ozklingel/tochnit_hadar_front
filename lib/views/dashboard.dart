import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHome();
  }
}

class _MyHome extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("תוכנית הדר"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Comment Icon',
              onPressed: () {
                //implement notifications here
              },
            ), //IconButton
          ], //<Widget>[]
          backgroundColor: Colors.grey,
          elevation: 50.0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu Icon',
            onPressed: () {
              //implement hamburger  here
            },
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ), //AppBar
        body: const Center(
          child: Text(
            "שלום חבר",
            style: TextStyle(fontSize: 24),
          ), //Text
        ), //Center
      ), //Scaffold
    );
  }
}
