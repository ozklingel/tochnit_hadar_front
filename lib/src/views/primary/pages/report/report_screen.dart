import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: Center(
        child: Text(GoRouterState.of(context).path ?? ''),
      ),
    );
  }
}
