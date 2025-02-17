import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/tasks/controller/tasks_controller.dart';
import 'package:hadar_program/src/views/widgets/images/avatar_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskCard extends HookConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.isSelected,
    this.onTap,
    this.showCheckbox = false,
  });

  final bool isSelected;
  final TaskDto task;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;
  final bool showCheckbox;

  @override
  Widget build(BuildContext context, ref) {
    final status = useState(task.status);
    final apprentice =
        ref.watch(personasControllerProvider).valueOrNull?.firstWhere(
              (element) => task.subject.contains(element.id),
              orElse: () => const PersonaDto(),
            );
    final apprenticeName = apprentice?.fullName ?? '';

    return Opacity(
      opacity: showCheckbox && status.value.isDone ? .6 : 1,
      child: Material(
        color: isSelected ? AppColors.blue07 : Colors.transparent,
        child: InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          child: ListTile(
            leading: showCheckbox
                ? Checkbox(
                    value: status.value.isDone,
                    onChanged: (value) {
                      status.value = value! ? TaskStatus.done : TaskStatus.todo;
                      ref
                          .read(tasksControllerProvider.notifier)
                          .toggleTodo(task);
                    },
                  )
                : Stack(
                    children: [
                      AvatarWidget(
                        radius: 16,
                        avatarUrl: apprentice?.avatar ?? '',
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor:
                              isSelected ? AppColors.green1 : AppColors.white,
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 12,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor:
                                        apprentice?.callStatus.toColor(),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
            title: Text(
              apprenticeName.isNotEmpty ? apprenticeName : task.title,
              style: TextStyles.s18w500cGray1,
            ),
            subtitle: Text(
              "עברו ${DateTime.now().difference(task.dateTime.asDateTime).inDays} ימים מ${task.title}",
              style: TextStyles.s16w300cGray2,
            ),
            trailing: showCheckbox
                ? DefaultTextStyle(
                    style: TextStyles.s12w400cGrey5fRoboto,
                    child: Column(
                      children: [
                        Text(
                          task.dateTime.asDateTime.asDayMonthYearShortSlash,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.dateTime.asDateTime.asTimeAgo,
                        ),
                        const Icon(
                          FluentIcons.arrow_rotate_clockwise_24_regular,
                          size: 16,
                          color: AppColors.gray5,
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
