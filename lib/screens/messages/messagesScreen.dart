import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('messages'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('message Screen'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('SignOut'),
            )
          ],
        ),
      ),
    );
  }
}
