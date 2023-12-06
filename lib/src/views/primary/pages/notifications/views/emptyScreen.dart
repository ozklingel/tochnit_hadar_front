import 'package:flutter/material.dart';

class emptyScreen extends StatefulWidget {
  const emptyScreen({super.key});

  @override
  State<emptyScreen> createState() => _emptyScreenState();
}

class _emptyScreenState extends State<emptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/noData.png'), fit: BoxFit.cover),
      ),
    );
  }
}
