import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.green,
      child: Center(
        child: Text(GoRouterState.of(context).path ?? ''),
      ),
    );
  }
}
