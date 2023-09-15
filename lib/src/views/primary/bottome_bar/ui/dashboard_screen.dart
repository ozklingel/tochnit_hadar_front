import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/views/primary/bottome_bar/ui/widget/bottom_navigation_widget.dart';
import 'package:hadar_program/src/views/secondary/onboarding/onboarding_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Widget child;
  const DashboardScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      drawerEdgeDragWidth: 60,
      drawer: kDebugMode
          ? Drawer(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, OnboardingScreen.routeName);
                    },
                    child: const Text('Onboarding'),
                  ),
                ],
              ),
            )
          : null,
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
