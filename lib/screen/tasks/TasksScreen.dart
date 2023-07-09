import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TasksScreen'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('TasksScreen '),
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
