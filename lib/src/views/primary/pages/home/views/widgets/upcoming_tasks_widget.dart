import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
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
        .where((element) => element.event.isCall)
        .take(3)
        .toList();

    final meetings = tasksScreenController
        .where((element) => element.event.isMeeting)
        .take(3)
        .toList();

    final parents = tasksScreenController
        .where((element) => element.event.isParents)
        .take(3)
        .toList();

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 24),
            const Text(
              'משימות לביצוע',
              style: TextStyles.s20w500,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => const TasksRouteData().go(context),
              child: const Text(
                'הצג הכל',
                style: TextStyles.s14w300cBlue2,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),
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
                  children: calls.map(
                    (e) {
                      void onSelect() {
                        if (selectedCalls.value.contains(e)) {
                          selectedCalls.value = [
                            ...selectedCalls.value
                                .where((element) => element != e),
                          ];
                        } else {
                          selectedCalls.value = [...selectedCalls.value, e];
                        }
                      }

                      return TaskCard(
                        task: e,
                        isSelected: selectedCalls.value.contains(e),
                        onTap: selectedCalls.value.isEmpty
                            ? () => e.subject.isEmpty
                                ? null
                                : PersonaDetailsRouteData(id: e.subject.first)
                            : onSelect,
                        onLongPress: onSelect,
                      );
                    },
                  ).toList(),
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
                  children: meetings.map(
                    (e) {
                      void onSelect() {
                        if (selectedMeetings.value.contains(e)) {
                          selectedMeetings.value = [
                            ...selectedMeetings.value
                                .where((element) => element != e),
                          ];
                        } else {
                          selectedMeetings.value = [
                            ...selectedMeetings.value,
                            e,
                          ];
                        }
                      }

                      return TaskCard(
                        task: e,
                        isSelected: selectedMeetings.value.contains(e),
                        onTap: selectedMeetings.value.isEmpty
                            ? () => e.subject.isEmpty
                                ? null
                                : PersonaDetailsRouteData(id: e.subject.first)
                            : onSelect,
                        onLongPress: onSelect,
                      );
                    },
                  ).toList(),
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
                  children: parents.map(
                    (e) {
                      void onSelect() {
                        if (selectedParents.value.contains(e)) {
                          selectedParents.value = [
                            ...selectedParents.value
                                .where((element) => element != e),
                          ];
                        } else {
                          selectedParents.value = [
                            ...selectedParents.value,
                            e,
                          ];
                        }
                      }

                      return TaskCard(
                        task: e,
                        isSelected: selectedParents.value.contains(e),
                        onTap: selectedParents.value.isEmpty
                            ? () => e.subject.isEmpty
                                ? null
                                : PersonaDetailsRouteData(id: e.subject.first)
                            : onSelect,
                        onLongPress: onSelect,
                      );
                    },
                  ).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsRow extends ConsumerWidget {
  const _ActionsRow({
    required this.label,
    required this.selectedTasks,
  });

  final String label;
  final List<TaskDto> selectedTasks;

  @override
  Widget build(BuildContext context, ref) {
    final apprentices =
        ref.watch(personasControllerProvider).valueOrNull?.where(
                  (element) => selectedTasks
                      .map(
                        (e) => e.subject,
                      )
                      .expand((element) => element)
                      .contains(element.id),
                ) ??
            [];

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyles.s18w400cGray1,
          ),
          const Spacer(),
          if (selectedTasks.length == 1)
            Builder(
              builder: (context) {
                final persona = apprentices.singleWhere(
                  (element) => selectedTasks
                      .map((e) => e.subject)
                      .expand((element) => element)
                      .contains(element.id),
                  orElse: () => const PersonaDto(),
                );

                return Row(
                  children: [
                    IconButton(
                      onPressed: () => launchCall(phone: persona.phone),
                      icon: const Icon(FluentIcons.call_24_regular),
                    ),
                    IconButton(
                      onPressed: () => launchWhatsapp(phone: persona.phone),
                      icon: Assets.icons.whatsapp.svg(
                        height: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () => ReportNewRouteData(
                        initRecipients: selectedTasks
                            .map((e) => e.subject)
                            .expand((element) => element)
                            .toList(),
                      ).push(context),
                      icon: const Icon(FluentIcons.clipboard_task_24_regular),
                    ),
                    PopupMenuButton(
                      offset: const Offset(0, 32),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => launchSms(phone: [persona.phone]),
                          child: const Text('שליחת SMS'),
                        ),
                        PopupMenuItem(
                          onTap: () => PersonaDetailsRouteData(id: persona.id)
                              .push(context),
                          child: const Text('פרופיל אישי'),
                        ),
                      ],
                      icon: const Icon(FluentIcons.more_vertical_24_regular),
                    ),
                  ],
                );
              },
            )
          else if (selectedTasks.length > 1)
            IconButton(
              onPressed: () => ReportNewRouteData(
                initRecipients: selectedTasks
                    .map((e) => e.subject)
                    .expand((element) => element)
                    .toList(),
              ).push(context),
              icon: const Icon(FluentIcons.clipboard_task_24_regular),
            ),
        ],
      ),
    );
  }
}
