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
    return Badge(
      isLabelVisible: count > 0,
      label: Text(count.toString()),
      child: child,
    );
  }
}
