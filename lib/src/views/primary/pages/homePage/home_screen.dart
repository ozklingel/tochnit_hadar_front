import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: getAppBar(),
      ),
    );
  }

  getAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.grey,
      elevation: 50.0,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ), //IconButton
      ],
      leading: IconButton(
        icon: const Icon(Icons.menu),
        tooltip: 'Menu Icon',
        onPressed: () {
          //implement hamburger  here
        },
      ),
    );
  }
}
