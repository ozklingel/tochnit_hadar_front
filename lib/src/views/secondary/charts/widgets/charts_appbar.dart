import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';

class ChartsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChartsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('מדדים'),
      actions: [
        IconButton(
          onPressed: () => Toaster.unimplemented(),
          icon: const Icon(FluentIcons.search_24_regular),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
