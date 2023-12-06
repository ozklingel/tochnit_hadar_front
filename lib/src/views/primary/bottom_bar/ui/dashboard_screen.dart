import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/views/primary/bottom_bar/ui/widget/bottom_navigation_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({
    Key? key,
    required this.navShell,
    required this.children,
  }) : super(key: key ?? const ValueKey('navShellDashboardScreen'));

  final StatefulNavigationShell navShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: _AnimatedBranchContainer(
        currentIndex: navShell.currentIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationWidget(
        navShell: navShell,
      ),
    );
  }
}

class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed(
        (
          int index,
          Widget navigator,
        ) {
          return AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: Consts.defaultDurationM,
            child: AnimatedSlide(
              offset: index == currentIndex ? Offset.zero : const Offset(0, 1),
              duration: Consts.defaultDurationM,
              child: _branchNavigatorWrapper(index, navigator),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
