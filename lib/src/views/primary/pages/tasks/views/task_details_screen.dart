import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/fields/input_label.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskDetailsScreen extends ConsumerWidget {
  const TaskDetailsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(tasksControllerProvider).valueOrNull?.singleWhere(
              (element) => element.id == id,
              orElse: () => const TaskDto(),
            ) ??
        const TaskDto();

    return Scaffold(
      appBar: AppBar(
        title: const Text('משימה'),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 32),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('עריכה'),
                onTap: () => EditTaskRouteData(id: task.id).push(context),
              ),
              PopupMenuItem(
                child: const Text('מחיקה'),
                onTap: () => Toaster.unimplemented(),
              ),
            ],
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                InputFieldContainer(
                  label: 'המשימה',
                  child: Text(
                    task.title,
                    style: TextStyles.s14w400cGrey2,
                  ),
                ),
                InputFieldContainer(
                  label: 'פירוט',
                  child: Text(
                    task.details,
                    style: TextStyles.s14w400cGrey2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      FluentIcons.arrow_rotate_counterclockwise_24_regular,
                      color: AppColors.grey5,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.frequency,
                        style: TextStyles.s14w400cGrey2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
