import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApprenticeScreen extends StatelessWidget {
  const ApprenticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.orange,
      child: Center(
        child: Text(GoRouterState.of(context).path ?? ''),
      ),
    );
  }
}
