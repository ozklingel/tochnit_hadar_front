import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationDetailsScreen extends HookConsumerWidget {
  const NotificationDetailsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(
      tasksControllerProvider.select(
        (val) {
          return val.value!.firstWhere(
            (element) => element.id == id,
            orElse: () => const TaskDto(),
          );
        },
      ),
    );

    useEffect(
      () {
        ref.read(tasksControllerProvider.notifier).setToReadStatus(task);

        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'פרטי התראה',
          style: TextStyles.s22w400cGrey2,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: const Text('מחיקה'),
                onTap: () async {
                  final navContext = Navigator.of(context);

                  final result = await ref
                      .read(tasksControllerProvider.notifier)
                      .delete(task);

                  if (result) {
                    navContext.pop();
                  }
                },
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.event.name,
                  style: TextStyles.s18w500cGray2,
                ),
                const Spacer(),
                Text(
                  task.dateTime.asDateTime.asTimeAgoDayCutoff,
                  style: TextStyles.s12w400cGrey5fRoboto,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'בתאריך '
              '${task.dateTime.asDateTime.asDayMonthYearShortDot}',
              style: TextStyles.s14w400cGrey2,
            ),
            const SizedBox(height: 16),
            Text(task.details),
          ],
        ),
      ),
    );
  }
}
