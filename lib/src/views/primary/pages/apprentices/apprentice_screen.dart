import 'package:flutter/material.dart';

class ApprenticeScreen extends StatefulWidget {
  const ApprenticeScreen({Key? key}) : super(key: key);

  @override
  State<ApprenticeScreen> createState() => _ApprenticeScreenState();
}

class _ApprenticeScreenState extends State<ApprenticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apprentice'),
      ),
      body: const Center(
        child: Column(
          children: [Text('חניכים')],
        ),
      ),
    );
  }
}
