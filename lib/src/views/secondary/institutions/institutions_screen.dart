import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';

class InstitutionsScreen extends StatelessWidget {
  const InstitutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('מוסדות'),
        actions: [
          IconButton(
            onPressed: () => Toaster.unimplemented(),
            icon: const Icon(FluentIcons.search_24_regular),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Toaster.unimplemented(),
        backgroundColor: AppColors.blue02,
        shape: const CircleBorder(),
        child: const Icon(
          FluentIcons.add_24_regular,
          color: Colors.white,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  FluentIcons.arrow_sort_down_lines_24_regular,
                  color: AppColors.grey2,
                ),
                SizedBox(width: 4),
                Text(
                  '43 מוסדות',
                  style: TextStyles.s14w400cGrey5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
