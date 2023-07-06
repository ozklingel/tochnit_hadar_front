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
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        ///////////////1
        appBar: getAppBar(),
        ///////////2.
        body: getBody(),
        ///////3.
        bottomNavigationBar: getBottomBar(), //Center
      ), //Scaffold
    );
  }

  getAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("תוכנית הדר"),
      actions: <Widget>[
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  setState(() {
                    counter++;
                  });
                }),
            counter != 0
                ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : new Container()
          ],
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
    );
  }

  getBody() {
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Column contents horizontally,
        children: <Widget>[
          Row(
              //ROW 2
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Center(
                  child: Text(
                    "שלום חבר",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ]),
          Row(
            //Center Row contents horizontally,
            crossAxisAlignment:
                CrossAxisAlignment.center, //Center Row contents vertically,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Geeks",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "For",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Geeks",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              )
            ],
          ), //AppBar
        ]);
  }

  getBottomBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Calls',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
      ],
    );
  }
}
