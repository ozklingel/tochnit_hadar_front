import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
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
          right: -4,
          top: -4,
          child: AnimatedSwitcher(
            duration: Consts.defaultDurationXL,
            child: isLoading
                ? const SizedBox.square(
                    key: ValueKey('unreadCountLoadingTrue'),
                    dimension: 14,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : const SizedBox.shrink(
                    key: ValueKey('unreadCountLoadingFalse'),
                  ),
          ),
        ),
      ],
    );
  }
}
