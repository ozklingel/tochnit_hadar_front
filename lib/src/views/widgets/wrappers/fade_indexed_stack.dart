// https://gist.github.com/diegoveloper/1cd23e79a31d0c18a67424f0cbdfd7ad
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (!mounted) return super.didUpdateWidget(oldWidget);

    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Consts.defaultDurationXL);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      // required for errors not to occur during rapid switching between tabs
      child: RepaintBoundary(
        child: IndexedStack(
          index: widget.index,
          children: widget.children,
        ),
      ),
    );
  }
}
