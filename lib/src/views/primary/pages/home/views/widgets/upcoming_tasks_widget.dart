import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/cards/task_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingTasksWidget extends HookConsumerWidget {
  const UpcomingTasksWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tasksScreenController =
        ref.watch(tasksControllerProvider).valueOrNull ?? [];
    final selectedCalls = useState(<TaskDto>[]);
    final selectedMeetings = useState(<TaskDto>[]);
    final selectedParents = useState(<TaskDto>[]);

    final calls = tasksScreenController
        .where(
          (element) => element.reportEventType == TaskType.call,
        )
        .take(3)
        .toList();

    final meetings = tasksScreenController
        .where(
          (element) => element.reportEventType == TaskType.meeting,
        )
        .take(3)
        .toList();

    final parents = tasksScreenController
        .where(
          (element) => element.reportEventType == TaskType.parentsMeeting,
        )
        .take(3)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'משימות לביצוע',
                style: TextStyles.s20w500,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => const TasksRouteData().go(context),
                child: const Text(
                  'הצג הכל',
                  style: TextStyles.s14w300cGray2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ActionsRow(
            label: 'שיחות',
            selectedTasks: selectedCalls.value,
          ),
          const SizedBox(height: 6),
          if (calls.isEmpty)
            const Text(
              'אין שיחות שמחכות לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: calls
                  .map(
                    (e) => TaskCard(
                      isSelected: selectedCalls.value.contains(e),
                      onTap: () => e.apprenticeIds.isEmpty
                          ? null
                          : ApprenticeDetailsRouteData(
                              id: e.apprenticeIds.first,
                            ),
                      onLongPress: () {
                        if (selectedCalls.value.contains(e)) {
                          final newList = selectedCalls.value;
                          newList.remove(e);
                          selectedCalls.value = [...newList];
                        } else {
                          selectedCalls.value = [...selectedCalls.value, e];
                        }
                      },
                      task: e,
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 24),
          _ActionsRow(
            label: 'מפגשים',
            selectedTasks: selectedMeetings.value,
          ),
          const SizedBox(height: 6),
          if (meetings.isEmpty)
            const Text(
              'אין מפגשים שמחכים לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: meetings
                  .map(
                    (e) => TaskCard(
                      isSelected: selectedMeetings.value.contains(e),
                      onTap: () => e.apprenticeIds.isEmpty
                          ? null
                          : ApprenticeDetailsRouteData(
                              id: e.apprenticeIds.first,
                            ),
                      onLongPress: () {
                        if (selectedMeetings.value.contains(e)) {
                          final newList = selectedMeetings.value;
                          newList.remove(e);
                          selectedMeetings.value = [...newList];
                        } else {
                          selectedMeetings.value = [
                            ...selectedMeetings.value,
                            e,
                          ];
                        }
                      },
                      task: e,
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 24),
          _ActionsRow(
            label: 'שיחות להורים',
            selectedTasks: selectedParents.value,
          ),
          const SizedBox(height: 6),
          if (parents.isEmpty)
            const Text(
              'אין שיחות להורים שמחכות לביצוע',
              style: TextStyles.s16w300cGray2,
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: parents
                  .map(
                    (e) => TaskCard(
                      isSelected: selectedParents.value.contains(e),
                      onTap: () => e.apprenticeIds.isEmpty
                          ? null
                          : ApprenticeDetailsRouteData(
                              id: e.apprenticeIds.first,
                            ),
                      onLongPress: () {
                        if (selectedParents.value.contains(e)) {
                          final newList = selectedParents.value;
                          newList.remove(e);
                          selectedParents.value = [...newList];
                        } else {
                          selectedParents.value = [...selectedParents.value, e];
                        }
                      },
                      task: e,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.label,
    required this.selectedTasks,
  });

  final String label;
  final List<TaskDto> selectedTasks;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyles.s18w400cGray1,
          ),
          const Spacer(),
          if (selectedTasks.length == 1) ...[
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.call_24_regular),
            ),
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: Assets.icons.whatsapp.svg(
                height: 20,
              ),
            ),
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
            PopupMenuButton(
              offset: const Offset(0, 32),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Toaster.unimplemented(),
                  child: const Text('שליחת SMS'),
                ),
                PopupMenuItem(
                  onTap: () => Toaster.unimplemented(),
                  child: const Text('פרופיל אישי'),
                ),
              ],
              icon: const Icon(FluentIcons.more_vertical_24_regular),
            ),
          ] else if (selectedTasks.length > 1)
            IconButton(
              onPressed: () => Toaster.unimplemented(),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
        ],
      ),
    );
  }
}
