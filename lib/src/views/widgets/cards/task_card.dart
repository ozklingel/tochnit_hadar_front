import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/models/task/task.dto.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/widgets/images/avatar_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.isSelected,
    this.onTap,
    this.onCheckboxTap,
  });

  final bool isSelected;
  final TaskDto task;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;
  final Function(bool?)? onCheckboxTap;

  @override
  Widget build(BuildContext context, ref) {
    final apprentice =
        ref.watch(personasControllerProvider).valueOrNull?.firstWhere(
                  (element) => task.subject.contains(element.id),
                  orElse: () => const PersonaDto(),
                ) ??
            const PersonaDto();

    return Material(
      color: isSelected ? AppColors.blue07 : Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: ListTile(
          leading: onCheckboxTap == null
              ? _ApprenticeAvatar(
                  apprentice: apprentice,
                  isSelected: isSelected,
                )
              : Checkbox(
                  value: task.status == TaskStatus.done,
                  onChanged: onCheckboxTap,
                ),
          title: Text(
            apprentice.fullName,
            style: TextStyles.s18w500cGray1,
          ),
          subtitle: Text(
            task.details,
            style: TextStyles.s16w300cGray2,
          ),
          trailing: onCheckboxTap == null
              ? null
              : DefaultTextStyle(
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
                ),
        ),
      ),
    );
  }
}

class _ApprenticeAvatar extends StatelessWidget {
  const _ApprenticeAvatar({
    required this.apprentice,
    required this.isSelected,
  });

  final PersonaDto apprentice;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AvatarWidget(
          radius: 16,
          avatarUrl: apprentice.avatar,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 6,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: apprentice.callStatus.toColor(),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: isSelected
              ? const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: AppColors.green1,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
