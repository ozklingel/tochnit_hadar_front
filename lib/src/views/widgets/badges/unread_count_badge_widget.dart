import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnreadCounterBadgeWidget extends ConsumerWidget {
  const UnreadCounterBadgeWidget({
    super.key,
    required this.child,
    this.count = 0,
    this.isLoading = false,
  });

  final Widget child;
  final int count;
  final bool isLoading;

  @override
  Widget build(BuildContext context, ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: 10,
          top: 10,
          child: count < 1
              ? const SizedBox.shrink()
              : const IgnorePointer(
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 3,
                    child: Text(
                      "",
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
