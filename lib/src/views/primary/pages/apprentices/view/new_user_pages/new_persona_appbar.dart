import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class NewPersonaAppbar extends StatelessWidget implements PreferredSizeWidget {
  const NewPersonaAppbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyles.s22w400cGrey2,
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
