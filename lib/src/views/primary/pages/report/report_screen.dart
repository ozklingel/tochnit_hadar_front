import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('report'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('report Screen'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('SignOut'),
            ),
          ],
        ),
      ),
    );
  }
}
