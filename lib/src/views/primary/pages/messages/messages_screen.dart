import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.purple,
      child: Center(
        child: Text(GoRouterState.of(context).path ?? ''),
      ),
    );
  }
}
