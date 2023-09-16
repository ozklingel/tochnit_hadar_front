import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/views/primary/bottome_bar/ui/widget/bottom_navigation_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({
    Key? key,
    required this.navShell,
  }) : super(key: key ?? const ValueKey('navShellDashboardScreen'));

  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: navShell,
      bottomNavigationBar: BottomNavigationWidget(
        navShell: navShell,
      ),
    );
  }
}
